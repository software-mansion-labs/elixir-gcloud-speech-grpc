defmodule GCloud.SpeechAPI.Streaming.Client do
  use GenServer
  alias __MODULE__.Connection
  alias Google.Cloud.Speech.V1.{StreamingRecognizeRequest, StreamingRecognizeResponse}

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

  @doc """
  Starts a linked client process.

  Possible options are:
  - `target` - A pid of a process that will receive recognition results. Defaults to `self()`.
  - `start_time` - Time by which response times will be shifted. Defaults to `0`.
  """
  @spec start_link(options :: Keyword.t()) :: {:ok, pid} | {:error, any()}
  def start_link(options \\ []) do
    do_start(:start_link, options)
  end

  @doc """
  Starts a client process without links.

  See `start_link/1` for more info
  """
  @spec start(target :: pid()) :: {:ok, pid} | {:error, any()}
  def start(options \\ []) do
    do_start(:start, options)
  end

  defp do_start(fun, options) do
    options = %{target: self(), start_time: 0} |> Map.merge(options |> Map.new())
    apply(GenServer, fun, [__MODULE__, options])
  end

  @doc """
  Stops a client process.
  """
  @spec stop(client :: pid()) :: :ok
  defdelegate stop(pid), to: GenServer

  @doc """
  Sends a request to the API. If option `end_stream: true` is passed,
  closes a client-side gRPC stream.
  """
  @spec send_request(client :: pid(), StreamingRecognizeRequest.t(), Keyword.t()) :: :ok
  def send_request(pid, request, opts \\ []) do
    GenServer.cast(pid, {:send_request, request, opts})
    :ok
  end

  @impl true
  def init(opts) do
    {:ok, conn} = Connection.start_link()
    {:ok, opts |> Map.merge(%{conn: conn})}
  end

  @impl true
  def handle_cast({:send_request, request, opts}, state) do
    :ok = state.conn |> Connection.send_request(request, opts)
    {:noreply, state}
  end

  @impl true
  def handle_info(%StreamingRecognizeResponse{} = response, state) do
    %{start_time: start_time} = state

    response =
      response
      |> Map.update!(:results, &Enum.map(&1, fn res -> update_result_time(res, start_time) end))

    send(state.target, response)
    {:noreply, state}
  end

  @impl true
  def terminate(_reason, state) do
    state.conn |> Connection.stop()
  end

  defp update_result_time(result, start_time) do
    result
    |> Map.update!(:result_end_time, &(start_time + &1.nanos + &1.seconds * 1_000_000_000))
  end
end
