defmodule GCloudSpeechToText.API.StreamingClient do
  alias GCloudSpeechToText.API
  alias Google.Cloud.Speech.V1.Speech.Stub, as: SpeechStub
  alias Google.Cloud.Speech.V1.StreamingRecognizeRequest

  @moduledoc """
  A client process for Streaming API.

  Once a client is started, it establishes a connection to the Streaming  API, gets ready to send requests to the API and forwards incoming responses to a set process.
  """

  @timeout 50

  @doc """
  Starts a linked client process.

  `target` is a pid of a process that will receive recognition results
  """
  @spec start_link(target :: pid()) :: {:ok, pid} | {:error, any()}
  def start_link(target \\ self()) do
    do_start(:spawn_link, target)
  end

  @doc """
  Starts a client process without links.

  See `start_link/1` for more info
  """
  @spec start(target :: pid()) :: {:ok, pid} | {:error, any()}
  def start(target \\ self()) do
    do_start(:spawn, target)
  end

  defp do_start(fun, target) do
    with {:ok, channel} <- GCloudSpeechToText.API.connect() do
      pid = apply(Kernel, fun, [__MODULE__, :init, [channel, target]])
      {:ok, pid}
    end
  end

  @doc """
  Stops a client process.
  """
  @spec stop(client :: pid()) :: :ok
  def stop(pid) do
    send(pid, {__MODULE__, :stop})
    :ok
  end

  @doc """
  Sends a request to the API. If option `end_stream: true` is passed,
  closes a client-side gRPC stream.
  """
  @spec send_request(client :: pid(), StreamingRecognizeRequest.t(), Keyword.t()) :: :ok
  def send_request(pid, request, opts \\ []) do
    send(pid, {__MODULE__, :send_request, request, opts})
    :ok
  end

  @doc false
  # entry point of client process
  def init(channel, target) do
    request_opts = API.request_opts()
    stream = SpeechStub.streaming_recognize(channel, request_opts)
    loop(%{channel: channel, stream: stream, target: target, recv_enum: nil})
  end

  defp loop(state) do
    state
    |> grpc_receive()
    |> calls_and_casts()
    |> loop()
  end

  defp grpc_receive(%{stream: stream, recv_enum: nil} = state) do
    # recv reads process mailbox (messages from :gun library)
    res = GRPC.Stub.recv(stream, timeout: @timeout)

    case res do
      {:ok, enum} -> grpc_receive(%{state | recv_enum: enum})
      {:error, %GRPC.RPCError{status: 4}} -> state
      {:error, error} -> exit(error)
    end
  end

  defp grpc_receive(%{target: target, recv_enum: enum} = state) do
    enum
    |> Enum.each(fn
      {:ok, message} -> send(target, message)
      {:error, %GRPC.RPCError{status: 4}} -> nil
      {:error, error} -> exit(error)
    end)

    state
  end

  defp calls_and_casts(%{channel: channel, stream: stream} = state) do
    receive do
      {__MODULE__, :send_request, request, opts} ->
        stream |> GRPC.Stub.send_request(request, opts)
        state

      {__MODULE__, :stop} ->
        API.disconnect(channel)
        exit(:normal)
    after
      @timeout -> state
    end
  end
end
