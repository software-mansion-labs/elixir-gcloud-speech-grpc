defmodule GCloud.SpeechAPI.Streaming.Client.Connection do
  @moduledoc false
  # This module wraps a crappy API of gRPC library that has a call reading
  # the process mailbox - `GRPC.Stub.recv/2`.
  # Using GenServer would break the calls to this function as `handle_info` callback
  # would consume any messages that should be parsed by `recv`

  alias GCloud.SpeechAPI
  alias Google.Cloud.Speech.V1.Speech.Stub, as: SpeechStub
  alias Google.Cloud.Speech.V1.StreamingRecognizeRequest

  require Logger

  @timeout 50

  @spec start_link(target :: pid()) :: {:ok, pid} | {:error, any()}
  def start_link(target \\ self()) do
    do_start(:spawn_link, target)
  end

  @spec start(target :: pid()) :: {:ok, pid} | {:error, any()}
  def start(target \\ self()) do
    do_start(:spawn, target)
  end

  defp do_start(fun, target) do
    with {:ok, channel} <- SpeechAPI.connect() do
      pid = apply(Kernel, fun, [__MODULE__, :init, [channel, target]])
      {:ok, pid}
    end
  end

  @spec stop(client :: pid()) :: :ok
  def stop(pid) do
    send(pid, {__MODULE__, :stop})
    :ok
  end

  @spec send_request(client :: pid(), StreamingRecognizeRequest.t(), Keyword.t()) :: :ok
  def send_request(pid, request, opts \\ []) do
    send(pid, {__MODULE__, :send_request, request, opts})
    :ok
  end

  @spec end_stream(client :: pid()) :: :ok
  def end_stream(pid) do
    send(pid, {__MODULE__, :end_stream})
    :ok
  end

  @doc false
  # entry point of client process
  def init(channel, target) do
    request_opts = SpeechAPI.request_opts()
    stream = SpeechStub.streaming_recognize(channel, request_opts)
    loop(%{channel: channel, eos: false, stream: stream, target: target, recv_enum: nil})
  end

  defp loop(state) do
    state
    |> grpc_receive()
    |> receive_others()
    |> loop()
  end

  defp grpc_receive(%{stream: stream, recv_enum: nil} = state) do
    # recv reads process mailbox (messages from :gun library)
    res = GRPC.Stub.recv(stream, timeout: @timeout)

    case res do
      {:ok, enum} -> grpc_receive(%{state | recv_enum: enum})
      {:error, error} -> handle_error(error, state)
    end
  end

  defp grpc_receive(%{target: target, recv_enum: enum} = state) do
    enum
    |> Enum.each(fn
      {:ok, message} -> send(target, message)
      {:error, error} -> handle_error(error, state)
    end)

    state
  end

  defp receive_others(%{channel: channel, stream: stream} = state) do
    receive do
      {__MODULE__, :send_request, request, opts} ->
        stream |> GRPC.Stub.send_request(request, opts)
        state

      {__MODULE__, :end_stream} ->
        if state.eos do
          state
        else
          stream |> GRPC.Stub.end_stream()
          %{state | eos: true}
        end

      {__MODULE__, :stop} ->
        SpeechAPI.disconnect(channel)
        exit(:normal)
    after
      @timeout -> state
    end
  end

  defp handle_error(%GRPC.RPCError{status: 4, message: "timeout when waiting for server"}, state) do
    # Error from lib, not the server, indicating the timeout passed before receiving message
    # which is normal in this case
    # https://github.com/elixir-grpc/grpc/blob/387eb5df5413fe89d7b62246d6e5b094fd82e0f5/lib/grpc/adapter/gun.ex#L216
    state
  end

  defp handle_error(%GRPC.RPCError{message: ":normal", status: 2}, state) do
    # Seems like an error in GRPC library
    Logger.debug(":normal error")
    state
  end

  defp handle_error(
         %GRPC.RPCError{message: ":closed: 'The connection was lost.'", status: 2},
         _state
       ) do
    # Seems like yet another error in GRPC library, fixed on master
    # It means the connection has been closed by server
    exit(:normal)
  end

  defp handle_error(error, _state) do
    Logger.error(inspect(error))
    exit(:error)
  end
end
