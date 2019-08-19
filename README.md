# Google Cloud Speech gRPC API client

Elixir client for Google Cloud Speech-to-Text API using gRPC

## Installation

The package can be installed by adding `:gcloud_speech_grpc` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:gcloud_speech_grpc, "~> 0.1.0"}
  ]
end
```

## Configuration

This library uses [`Goth`](https://github.com/peburrows/goth) to obtain authentication tokens. It requires Google Cloud credendials to be configured. See [Goth's README](https://github.com/peburrows/goth#installation) for details.

Tests with tag `:external` communicate with Google APIs and require such config, thus are
excluded by default, use `mix test --include external` to run them.

## Usage example

```elixir
alias Google.Cloud.Speech.V1.{
  RecognitionConfig,
  StreamingRecognitionConfig,
  StreamingRecognizeRequest,
  StreamingRecognizeResponse
}

alias GCloud.SpeechAPI.Streaming.Client

cfg =
  RecognitionConfig.new(
    audio_channel_count: 1,
    encoding: :FLAC,
    language_code: "en-GB",
    sample_rate_hertz: 16000
  )

str_cfg =
  StreamingRecognitionConfig.new(
    config: cfg,
    interim_results: false
  )

str_cfg_req =
  StreamingRecognizeRequest.new(
    streaming_request: {:streaming_config, str_cfg}
  )

<<part_a::binary-size(48277), part_b::binary-size(44177),
  part_c::binary>> = File.read!("test/fixtures/sample.flac")

content_reqs =
  [part_a, part_b, part_c] |> Enum.map(fn data ->
    StreamingRecognizeRequest.new(
      streaming_request: {:audio_content, data}
    )
  end)

{:ok, client} = Client.start_link()
client |> Client.send_request(str_cfg_req)

content_reqs |> Enum.each(fn stream_audio_req ->
  Client.send_request(
    client,
    stream_audio_req
  )
end)

Client.end_stream(client)

receive do
  %StreamingRecognizeResponse{results: results} ->
    IO.inspect(results)
end
```

## Auto-generated modules

This library uses [`protobuf-elixir`](https://github.com/tony612/protobuf-elixir) and its `protoc-gen-elixir` plugin to generate Elixir modules from `*.proto` files for Google's Speech gRPC API. The documentation for the types defined in `*.proto` files can be found [here](https://cloud.google.com/speech-to-text/docs/reference/rpc/google.cloud.speech.v1)

### Mapping between Protobuf types and Elixir modules

Since the auto-generated modules have poor typing and no docs, the mapping may not be obvious. Here are some clues about how to use them:

* Structs defined in these modules should be created with `new/1` function accepting keyword list with values for fields
* when message field is an union field, it should be set to a tuple with atom indicating content of this field and an actual value, e.g. for `StreamingRecognizeRequest` the field `streaming_request` can be set to either `{:streaming_config, config}` or `{:audio_content, "binary_with_audio_data"}`
* Fields of enum types can be set to an integer or an atom matching the enum, e.g. value of field `:audio_encoding` in `RecognitionConfig` can be set to `:FLAC` or `2`

## Fixture

A recording fragment in `test/fixtures` comes from an audiobook
"The adventures of Sherlock Holmes (version 2)" available on [LibriVox](https://librivox.org/the-adventures-of-sherlock-holmes-by-sir-arthur-conan-doyle/)

## Status

Current version of library supports only Streaming API, regular and LongRunning are not implemented

## Copyright and License

Copyright 2019, [Software Mansion](https://swmansion.com/?utm_source=git&utm_medium=readme&utm_campaign=elixir-gcloud-speech-to-text)

[![Software Mansion](https://membraneframework.github.io/static/logo/swm_logo_readme.png)](https://swmansion.com/?utm_source=git&utm_medium=readme&utm_campaign=elixir-gcloud-speech-to-text-gcp-speech)

Licensed under the [Apache License, Version 2.0](LICENSE)
