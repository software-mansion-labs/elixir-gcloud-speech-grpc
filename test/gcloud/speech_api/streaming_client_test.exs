defmodule GCloud.SpeechAPI.Streaming.ClientTest do
  use ExUnit.Case, async: true

  alias Google.Cloud.Speech.V1.{
    RecognitionConfig,
    SpeechRecognitionAlternative,
    StreamingRecognitionConfig,
    StreamingRecognitionResult,
    StreamingRecognizeRequest,
    StreamingRecognizeResponse
  }

  @module GCloud.SpeechAPI.Streaming.Client

  @tag :external
  test "regcognize" do
    cfg =
      RecognitionConfig.new(
        audio_channel_count: 1,
        encoding: :FLAC,
        language_code: "en-GB",
        sample_rate_hertz: 16000
      )

    str_cfg = StreamingRecognitionConfig.new(config: cfg, interim_results: false)

    str_cfg_req = StreamingRecognizeRequest.new(streaming_request: {:streaming_config, str_cfg})

    fixture_path = "../../fixtures/sample.flac" |> Path.expand(__DIR__)

    <<part_a::binary-size(48277), part_b::binary-size(44177), part_c::binary>> =
      File.read!(fixture_path)

    content_reqs =
      [part_a, part_b, part_c]
      |> Enum.map(fn data ->
        StreamingRecognizeRequest.new(streaming_request: {:audio_content, data})
      end)

    assert {:ok, client} = @module.start_link()
    client |> @module.send_request(str_cfg_req)

    content_reqs
    |> Enum.each(fn stream_audio_req ->
      @module.send_request(
        client,
        stream_audio_req
      )
    end)

    @module.end_stream(client)

    assert_receive %StreamingRecognizeResponse{results: results}, 5000
    assert [%StreamingRecognitionResult{alternatives: alternative}] = results
    assert [%SpeechRecognitionAlternative{transcript: transcript}] = alternative

    assert transcript ==
             "Adventure 1 a scandal in Bohemia from the Adventures of Sherlock Holmes by Sir Arthur Conan Doyle"
  end

  test "shoutdown on monitored process down" do
    target = self()

    task =
      Task.async(fn ->
        send(target, {:client, @module.start(monitor_target: true)})
        receive do: (:exit -> :ok)
      end)

    assert_receive {:client, {:ok, client}}, 2000
    ref = Process.monitor(client)
    send(task.pid, :exit)
    assert :ok = Task.await(task)
    assert_receive {:DOWN, ^ref, :process, ^client, :normal}
  end
end
