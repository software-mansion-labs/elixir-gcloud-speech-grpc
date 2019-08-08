defmodule GCloud.SpeechAPI.Streaming.Client.Connection do
  @moduledoc false
  alias GCloud.SpeechAPI
  alias Google.Cloud.Speech.V1.Speech.Stub, as: SpeechStub
  alias Google.Cloud.Speech.V1.StreamingRecognizeRequest

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

  @doc false
  # entry point of client process
  def init(channel, target) do
    request_opts = SpeechAPI.request_opts()
    stream = SpeechStub.streaming_recognize(channel, request_opts)
    loop(%{channel: channel, stream: stream, target: target, recv_enum: nil})
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

      {__MODULE__, :stop} ->
        SpeechAPI.disconnect(channel)
        exit(:normal)
    after
      @timeout -> state
    end
  end

  defp handle_error(%GRPC.RPCError{status: 4}, state), do: state

  # XD
  defp handle_error(%GRPC.RPCError{message: ":normal", status: 2}, state), do: state

  defp handle_error(error, _state) do
    # FIXME use logger
    IO.inspect(self())
    IO.inspect(error)
    # TODO send error to the target?
    exit(:error)
  end
end
