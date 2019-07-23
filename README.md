# [WIP] Google Cloud Speech-to-Text API client

Elixir client for Google Cloud Speech-to-Text API using gRPC

## Installation

When published, the package can be installed by adding `:gcloud_speech_to_text` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:gcloud_speech_to_text, "~> 0.1.0"}
  ]
end
```

## Auto-generated modules

This library uses [`protobuf-elixir`](https://github.com/tony612/protobuf-elixir) and its `protoc-gen-elixir` plugin to generate Elixir modules from `*.proto` files for Google's Speech gRPC API. The documentation for the types defined in `*.proto` files can be found [here](https://cloud.google.com/speech-to-text/docs/reference/rpc/google.cloud.speech.v1)

### Mapping between Protobuf types and Elixir modules

Since the auto-generated modules have poor typing and no docs, the mapping may not be obvious. Here are some clues about how to use them:

* Structs defined in these modules should be created with `new/1` function accepting keyword list with values for fields
* when message field is an union field, it should be set to a tuple with atom indicating content of this field and an actual value, e.g. for `StreamingRecognizeRequest` the field `streaming_request` can be set to either `{:streaming_config, config}` or `{:audio_content, "binary_with_audio_data"}`
* Fields of enum types can be set to an integer or an atom matching the enum, e.g. value of field `:audio_encoding` in `RecognitionConfig` can be set to `:FLAC` or `2`

## Sponsors

This project is sponsored by [Abridge AI, Inc.](https://abridge.com)

## Copyright and License

Copyright 2019, [Software Mansion](https://swmansion.com/?utm_source=git&utm_medium=readme&utm_campaign=elixir-gcloud-speech-to-text)

[![Software Mansion](https://membraneframework.github.io/static/logo/swm_logo_readme.png)](https://swmansion.com/?utm_source=git&utm_medium=readme&utm_campaign=elixir-gcloud-speech-to-text-gcp-speech)

Licensed under the [Apache License, Version 2.0](LICENSE)
