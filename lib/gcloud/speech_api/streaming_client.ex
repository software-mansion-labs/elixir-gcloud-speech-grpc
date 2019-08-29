defmodule GCloud.SpeechAPI.Streaming.Client do
  @moduledoc """
  A client process for Streaming API.

  Once a client is started, it establishes a connection to the Streaming API,
  gets ready to send requests to the API and forwards incoming responses to a set process.

  ## Requests

  The requests can be sent using `send_request/3`. Each request should be a
  `t:Google.Cloud.Speech.V1.StreamingRecognizeRequest.t/0` struct created using
  `Google.Cloud.Speech.V1.StreamingRecognizeRequest.new/1` accepting keyword with struct fields.
  This is an auto-generated module, so check out [this notice](readme.html#auto-generated-modules) and
  [API reference](https://cloud.google.com/speech-to-text/docs/reference/rpc/google.cloud.speech.v1#google.cloud.speech.v1.StreamingRecognizeRequest)

  ## Usage

  1. Start the client
  1. Send request with `Google.Cloud.Speech.V1.StreamingRecognitionConfig`
  1. Send request(s) with `Google.Cloud.Speech.V1.RecognitionAudio` containing audio data
  1. (async) Receive messages conatining `Google.Cloud.Speech.V1.SpeechRecognitionResult`
  1. Send final `Google.Cloud.Speech.V1.RecognitionAudio` with option `end_stream: true`
     or call `end_stream/1` after final audio chunk has been sent.
  1. Stop the client after receiving all results

  See [README](readme.html) for code example
  """

  use GenServer

  alias __MODULE__.Connection

  alias Google.Cloud.Speech.V1.{
    StreamingRecognizeRequest,
    StreamingRecognizeResponse,
    SpeechRecognitionAlternative,
    WordInfo
  }

  alias Google.Protobuf.Duration

  @nanos_per_second 1_000_000_000

  @doc """
  Starts a linked client process.

  Possible options are:
  - `target` - A pid of a process that will receive recognition results. Defaults to `self()`.
  - `monitor_target` - If set to true, a client will monitor the target and shutdown
  if the target is down
  - `start_time` - Time by which response times will be shifted in nanoseconds. Defaults to `0` ns.
  """
  @spec start_link(options :: Keyword.t()) :: {:ok, pid} | {:error, any()}
  def start_link(options \\ []) do
    do_start(:start_link, options)
  end

  @doc """
  Starts a client process without links.

  See `start_link/1` for more info
  """
  @spec start(options :: Keyword.t()) :: {:ok, pid} | {:error, any()}
  def start(options \\ []) do
    do_start(:start, options)
  end

  defp do_start(fun, options) do
    options =
      options
      |> Map.new()
      |> Map.put_new(:target, self())
      |> Map.put_new(:monitor_target, false)
      |> Map.put_new(:start_time, 0)

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

  @doc """
  Closes a client-side gRPC stream.
  """
  @spec end_stream(client :: pid()) :: :ok
  def end_stream(pid) do
    GenServer.cast(pid, :end_stream)
    :ok
  end

  @impl true
  def init(opts) do
    {:ok, conn} = Connection.start_link()
    state = opts |> Map.merge(%{conn: conn})

    if opts.monitor_target do
      Process.monitor(opts.target)
    end

    {:ok, state}
  end

  @impl true
  def handle_cast({:send_request, request, opts}, state) do
    :ok = state.conn |> Connection.send_request(request, opts)
    {:noreply, state}
  end

  @impl true
  def handle_cast(:end_stream, state) do
    :ok = state.conn |> Connection.end_stream()
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
  def handle_info({:DOWN, _ref, :process, pid, _reason}, %{target: pid} = state) do
    {:stop, :normal, state}
  end

  @impl true
  def terminate(_reason, state) do
    state.conn |> Connection.stop()
  end

  defp update_result_time(result, start_time) when is_integer(start_time) do
    result
    |> Map.update!(:result_end_time, &duration_sum(&1, start_time))
    |> Map.update!(:alternatives, &update_alternatives(&1, start_time))
  end

  defp update_alternatives(alternatives, start_time) do
    alternatives |> Enum.map(&update_alternative(&1, start_time))
  end

  defp update_alternative(%SpeechRecognitionAlternative{words: words} = alt, start_time) do
    updated_words =
      words
      |> Enum.map(fn %WordInfo{} = info ->
        info
        |> Map.update!(:start_time, &duration_sum(&1, start_time))
        |> Map.update!(:end_time, &duration_sum(&1, start_time))
      end)

    %{alt | words: updated_words}
  end

  defp duration_sum(%Duration{} = a, b) when is_integer(b) do
    b + a.nanos + a.seconds * @nanos_per_second
  end
end
