defmodule Google.Cloud.Speech.V1.RecognitionConfig.AudioEncoding do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :ENCODING_UNSPECIFIED, 0
  field :LINEAR16, 1
  field :FLAC, 2
  field :MULAW, 3
  field :AMR, 4
  field :AMR_WB, 5
  field :OGG_OPUS, 6
  field :SPEEX_WITH_HEADER_BYTE, 7
  field :WEBM_OPUS, 9
end

defmodule Google.Cloud.Speech.V1.RecognitionMetadata.InteractionType do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :INTERACTION_TYPE_UNSPECIFIED, 0
  field :DISCUSSION, 1
  field :PRESENTATION, 2
  field :PHONE_CALL, 3
  field :VOICEMAIL, 4
  field :PROFESSIONALLY_PRODUCED, 5
  field :VOICE_SEARCH, 6
  field :VOICE_COMMAND, 7
  field :DICTATION, 8
end

defmodule Google.Cloud.Speech.V1.RecognitionMetadata.MicrophoneDistance do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :MICROPHONE_DISTANCE_UNSPECIFIED, 0
  field :NEARFIELD, 1
  field :MIDFIELD, 2
  field :FARFIELD, 3
end

defmodule Google.Cloud.Speech.V1.RecognitionMetadata.OriginalMediaType do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :ORIGINAL_MEDIA_TYPE_UNSPECIFIED, 0
  field :AUDIO, 1
  field :VIDEO, 2
end

defmodule Google.Cloud.Speech.V1.RecognitionMetadata.RecordingDeviceType do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :RECORDING_DEVICE_TYPE_UNSPECIFIED, 0
  field :SMARTPHONE, 1
  field :PC, 2
  field :PHONE_LINE, 3
  field :VEHICLE, 4
  field :OTHER_OUTDOOR_DEVICE, 5
  field :OTHER_INDOOR_DEVICE, 6
end

defmodule Google.Cloud.Speech.V1.StreamingRecognizeResponse.SpeechEventType do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :SPEECH_EVENT_UNSPECIFIED, 0
  field :END_OF_SINGLE_UTTERANCE, 1
  field :SPEECH_ACTIVITY_BEGIN, 2
  field :SPEECH_ACTIVITY_END, 3
  field :SPEECH_ACTIVITY_TIMEOUT, 4
end

defmodule Google.Cloud.Speech.V1.RecognizeRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :config, 1, type: Google.Cloud.Speech.V1.RecognitionConfig, deprecated: false
  field :audio, 2, type: Google.Cloud.Speech.V1.RecognitionAudio, deprecated: false
end

defmodule Google.Cloud.Speech.V1.LongRunningRecognizeRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :config, 1, type: Google.Cloud.Speech.V1.RecognitionConfig, deprecated: false
  field :audio, 2, type: Google.Cloud.Speech.V1.RecognitionAudio, deprecated: false

  field :output_config, 4,
    type: Google.Cloud.Speech.V1.TranscriptOutputConfig,
    json_name: "outputConfig",
    deprecated: false
end

defmodule Google.Cloud.Speech.V1.TranscriptOutputConfig do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  oneof :output_type, 0

  field :gcs_uri, 1, type: :string, json_name: "gcsUri", oneof: 0
end

defmodule Google.Cloud.Speech.V1.StreamingRecognizeRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  oneof :streaming_request, 0

  field :streaming_config, 1,
    type: Google.Cloud.Speech.V1.StreamingRecognitionConfig,
    json_name: "streamingConfig",
    oneof: 0

  field :audio_content, 2, type: :bytes, json_name: "audioContent", oneof: 0
end

defmodule Google.Cloud.Speech.V1.StreamingRecognitionConfig.VoiceActivityTimeout do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :speech_start_timeout, 1, type: Google.Protobuf.Duration, json_name: "speechStartTimeout"
  field :speech_end_timeout, 2, type: Google.Protobuf.Duration, json_name: "speechEndTimeout"
end

defmodule Google.Cloud.Speech.V1.StreamingRecognitionConfig do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :config, 1, type: Google.Cloud.Speech.V1.RecognitionConfig, deprecated: false
  field :single_utterance, 2, type: :bool, json_name: "singleUtterance"
  field :interim_results, 3, type: :bool, json_name: "interimResults"
  field :enable_voice_activity_events, 5, type: :bool, json_name: "enableVoiceActivityEvents"

  field :voice_activity_timeout, 6,
    type: Google.Cloud.Speech.V1.StreamingRecognitionConfig.VoiceActivityTimeout,
    json_name: "voiceActivityTimeout"
end

defmodule Google.Cloud.Speech.V1.RecognitionConfig do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :encoding, 1, type: Google.Cloud.Speech.V1.RecognitionConfig.AudioEncoding, enum: true
  field :sample_rate_hertz, 2, type: :int32, json_name: "sampleRateHertz"
  field :audio_channel_count, 7, type: :int32, json_name: "audioChannelCount"

  field :enable_separate_recognition_per_channel, 12,
    type: :bool,
    json_name: "enableSeparateRecognitionPerChannel"

  field :language_code, 3, type: :string, json_name: "languageCode", deprecated: false

  field :alternative_language_codes, 18,
    repeated: true,
    type: :string,
    json_name: "alternativeLanguageCodes"

  field :max_alternatives, 4, type: :int32, json_name: "maxAlternatives"
  field :profanity_filter, 5, type: :bool, json_name: "profanityFilter"
  field :adaptation, 20, type: Google.Cloud.Speech.V1.SpeechAdaptation

  field :speech_contexts, 6,
    repeated: true,
    type: Google.Cloud.Speech.V1.SpeechContext,
    json_name: "speechContexts"

  field :enable_word_time_offsets, 8, type: :bool, json_name: "enableWordTimeOffsets"
  field :enable_word_confidence, 15, type: :bool, json_name: "enableWordConfidence"
  field :enable_automatic_punctuation, 11, type: :bool, json_name: "enableAutomaticPunctuation"

  field :enable_spoken_punctuation, 22,
    type: Google.Protobuf.BoolValue,
    json_name: "enableSpokenPunctuation"

  field :enable_spoken_emojis, 23,
    type: Google.Protobuf.BoolValue,
    json_name: "enableSpokenEmojis"

  field :diarization_config, 19,
    type: Google.Cloud.Speech.V1.SpeakerDiarizationConfig,
    json_name: "diarizationConfig"

  field :metadata, 9, type: Google.Cloud.Speech.V1.RecognitionMetadata
  field :model, 13, type: :string
  field :use_enhanced, 14, type: :bool, json_name: "useEnhanced"
end

defmodule Google.Cloud.Speech.V1.SpeakerDiarizationConfig do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :enable_speaker_diarization, 1, type: :bool, json_name: "enableSpeakerDiarization"
  field :min_speaker_count, 2, type: :int32, json_name: "minSpeakerCount"
  field :max_speaker_count, 3, type: :int32, json_name: "maxSpeakerCount"
  field :speaker_tag, 5, type: :int32, json_name: "speakerTag", deprecated: true
end

defmodule Google.Cloud.Speech.V1.RecognitionMetadata do
  @moduledoc false

  use Protobuf, deprecated: true, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :interaction_type, 1,
    type: Google.Cloud.Speech.V1.RecognitionMetadata.InteractionType,
    json_name: "interactionType",
    enum: true

  field :industry_naics_code_of_audio, 3, type: :uint32, json_name: "industryNaicsCodeOfAudio"

  field :microphone_distance, 4,
    type: Google.Cloud.Speech.V1.RecognitionMetadata.MicrophoneDistance,
    json_name: "microphoneDistance",
    enum: true

  field :original_media_type, 5,
    type: Google.Cloud.Speech.V1.RecognitionMetadata.OriginalMediaType,
    json_name: "originalMediaType",
    enum: true

  field :recording_device_type, 6,
    type: Google.Cloud.Speech.V1.RecognitionMetadata.RecordingDeviceType,
    json_name: "recordingDeviceType",
    enum: true

  field :recording_device_name, 7, type: :string, json_name: "recordingDeviceName"
  field :original_mime_type, 8, type: :string, json_name: "originalMimeType"
  field :audio_topic, 10, type: :string, json_name: "audioTopic"
end

defmodule Google.Cloud.Speech.V1.SpeechContext do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :phrases, 1, repeated: true, type: :string
  field :boost, 4, type: :float
end

defmodule Google.Cloud.Speech.V1.RecognitionAudio do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  oneof :audio_source, 0

  field :content, 1, type: :bytes, oneof: 0
  field :uri, 2, type: :string, oneof: 0
end

defmodule Google.Cloud.Speech.V1.RecognizeResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :results, 2, repeated: true, type: Google.Cloud.Speech.V1.SpeechRecognitionResult
  field :total_billed_time, 3, type: Google.Protobuf.Duration, json_name: "totalBilledTime"

  field :speech_adaptation_info, 7,
    type: Google.Cloud.Speech.V1.SpeechAdaptationInfo,
    json_name: "speechAdaptationInfo"

  field :request_id, 8, type: :int64, json_name: "requestId"
end

defmodule Google.Cloud.Speech.V1.LongRunningRecognizeResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :results, 2, repeated: true, type: Google.Cloud.Speech.V1.SpeechRecognitionResult
  field :total_billed_time, 3, type: Google.Protobuf.Duration, json_name: "totalBilledTime"

  field :output_config, 6,
    type: Google.Cloud.Speech.V1.TranscriptOutputConfig,
    json_name: "outputConfig"

  field :output_error, 7, type: Google.Rpc.Status, json_name: "outputError"

  field :speech_adaptation_info, 8,
    type: Google.Cloud.Speech.V1.SpeechAdaptationInfo,
    json_name: "speechAdaptationInfo"

  field :request_id, 9, type: :int64, json_name: "requestId"
end

defmodule Google.Cloud.Speech.V1.LongRunningRecognizeMetadata do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :progress_percent, 1, type: :int32, json_name: "progressPercent"
  field :start_time, 2, type: Google.Protobuf.Timestamp, json_name: "startTime"
  field :last_update_time, 3, type: Google.Protobuf.Timestamp, json_name: "lastUpdateTime"
  field :uri, 4, type: :string, deprecated: false
end

defmodule Google.Cloud.Speech.V1.StreamingRecognizeResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :error, 1, type: Google.Rpc.Status
  field :results, 2, repeated: true, type: Google.Cloud.Speech.V1.StreamingRecognitionResult

  field :speech_event_type, 4,
    type: Google.Cloud.Speech.V1.StreamingRecognizeResponse.SpeechEventType,
    json_name: "speechEventType",
    enum: true

  field :speech_event_time, 8, type: Google.Protobuf.Duration, json_name: "speechEventTime"
  field :total_billed_time, 5, type: Google.Protobuf.Duration, json_name: "totalBilledTime"

  field :speech_adaptation_info, 9,
    type: Google.Cloud.Speech.V1.SpeechAdaptationInfo,
    json_name: "speechAdaptationInfo"

  field :request_id, 10, type: :int64, json_name: "requestId"
end

defmodule Google.Cloud.Speech.V1.StreamingRecognitionResult do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :alternatives, 1,
    repeated: true,
    type: Google.Cloud.Speech.V1.SpeechRecognitionAlternative

  field :is_final, 2, type: :bool, json_name: "isFinal"
  field :stability, 3, type: :float
  field :result_end_time, 4, type: Google.Protobuf.Duration, json_name: "resultEndTime"
  field :channel_tag, 5, type: :int32, json_name: "channelTag"
  field :language_code, 6, type: :string, json_name: "languageCode", deprecated: false
end

defmodule Google.Cloud.Speech.V1.SpeechRecognitionResult do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :alternatives, 1,
    repeated: true,
    type: Google.Cloud.Speech.V1.SpeechRecognitionAlternative

  field :channel_tag, 2, type: :int32, json_name: "channelTag"
  field :result_end_time, 4, type: Google.Protobuf.Duration, json_name: "resultEndTime"
  field :language_code, 5, type: :string, json_name: "languageCode", deprecated: false
end

defmodule Google.Cloud.Speech.V1.SpeechRecognitionAlternative do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :transcript, 1, type: :string
  field :confidence, 2, type: :float
  field :words, 3, repeated: true, type: Google.Cloud.Speech.V1.WordInfo
end

defmodule Google.Cloud.Speech.V1.WordInfo do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :start_time, 1, type: Google.Protobuf.Duration, json_name: "startTime"
  field :end_time, 2, type: Google.Protobuf.Duration, json_name: "endTime"
  field :word, 3, type: :string
  field :confidence, 4, type: :float
  field :speaker_tag, 5, type: :int32, json_name: "speakerTag", deprecated: false
end

defmodule Google.Cloud.Speech.V1.SpeechAdaptationInfo do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :adaptation_timeout, 1, type: :bool, json_name: "adaptationTimeout"
  field :timeout_message, 4, type: :string, json_name: "timeoutMessage"
end