defmodule GCloud.SpeechAPI.Streaming.Client do
  alias GCloud.SpeechAPI
  alias Google.Cloud.Speech.V1.Speech.Stub, as: SpeechStub
  alias Google.Cloud.Speech.V1.StreamingRecognizeRequest

  @moduledoc """
  A client process for Streaming API.

  Once a client is started, it establishes a connection to the Streaming API,
  gets ready to send requests to the API and forwards incoming responses to a set process.

  ## Requests

  The requests can be sent using `send_request/3`. Each request should be a
  `t:#{inspect(StreamingRecognizeRequest)}.t/0` struct created using
  `#{inspect(StreamingRecognizeRequest)}.new/1` accepting keyword with struct fields.
  This is an auto-generated module, so check out [this notice](readme.html#auto-generated-modules) and
  [API reference](https://cloud.google.com/speech-to-text/docs/reference/rpc/google.cloud.speech.v1#google.cloud.speech.v1.StreamingRecognizeRequest)

  ## Usage

  1. Start the client
  1. Send request with `Google.Cloud.Speech.V1.StreamingRecognitionConfig`
  1. Send request(s) with `Google.Cloud.Speech.V1.RecognitionAudio` containing audio data
  1. (async) Receive messages conatining `Google.Cloud.Speech.V1.SpeechRecognitionResult`
  1. Send final `Google.Cloud.Speech.V1.RecognitionAudio` with option `end_stream: true`
  1. Stop the client after receiving all results

  See [README](readme.html) for code example
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
    with {:ok, channel} <- SpeechAPI.connect() do
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
end
