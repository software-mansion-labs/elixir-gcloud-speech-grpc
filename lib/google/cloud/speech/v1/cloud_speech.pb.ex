defmodule Google.Cloud.Speech.V1.RecognizeRequest do
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use Protobuf, syntax: :proto3

  field :config, 1, type: Google.Cloud.Speech.V1.RecognitionConfig
  field :audio, 2, type: Google.Cloud.Speech.V1.RecognitionAudio
end

defmodule Google.Cloud.Speech.V1.LongRunningRecognizeRequest do
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use Protobuf, syntax: :proto3

  field :config, 1, type: Google.Cloud.Speech.V1.RecognitionConfig
  field :audio, 2, type: Google.Cloud.Speech.V1.RecognitionAudio
end

defmodule Google.Cloud.Speech.V1.StreamingRecognizeRequest do
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use Protobuf, syntax: :proto3

  oneof :streaming_request, 0
  field :streaming_config, 1, type: Google.Cloud.Speech.V1.StreamingRecognitionConfig, oneof: 0
  field :audio_content, 2, type: :bytes, oneof: 0
end

defmodule Google.Cloud.Speech.V1.StreamingRecognitionConfig do
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use Protobuf, syntax: :proto3

  field :config, 1, type: Google.Cloud.Speech.V1.RecognitionConfig
  field :single_utterance, 2, type: :bool
  field :interim_results, 3, type: :bool
end

defmodule Google.Cloud.Speech.V1.RecognitionConfig do
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use Protobuf, syntax: :proto3

  field :encoding, 1, type: Google.Cloud.Speech.V1.RecognitionConfig.AudioEncoding, enum: true
  field :sample_rate_hertz, 2, type: :int32
  field :audio_channel_count, 7, type: :int32
  field :enable_separate_recognition_per_channel, 12, type: :bool
  field :language_code, 3, type: :string
  field :max_alternatives, 4, type: :int32
  field :profanity_filter, 5, type: :bool
  field :speech_contexts, 6, repeated: true, type: Google.Cloud.Speech.V1.SpeechContext
  field :enable_word_time_offsets, 8, type: :bool
  field :enable_automatic_punctuation, 11, type: :bool
  field :metadata, 9, type: Google.Cloud.Speech.V1.RecognitionMetadata
  field :model, 13, type: :string
  field :use_enhanced, 14, type: :bool
end

defmodule Google.Cloud.Speech.V1.RecognitionConfig.AudioEncoding do
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use Protobuf, enum: true, syntax: :proto3

  field :ENCODING_UNSPECIFIED, 0
  field :LINEAR16, 1
  field :FLAC, 2
  field :MULAW, 3
  field :AMR, 4
  field :AMR_WB, 5
  field :OGG_OPUS, 6
  field :SPEEX_WITH_HEADER_BYTE, 7
end

defmodule Google.Cloud.Speech.V1.RecognitionMetadata do
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use Protobuf, syntax: :proto3

  field :interaction_type, 1,
    type: Google.Cloud.Speech.V1.RecognitionMetadata.InteractionType,
    enum: true

  field :industry_naics_code_of_audio, 3, type: :uint32

  field :microphone_distance, 4,
    type: Google.Cloud.Speech.V1.RecognitionMetadata.MicrophoneDistance,
    enum: true

  field :original_media_type, 5,
    type: Google.Cloud.Speech.V1.RecognitionMetadata.OriginalMediaType,
    enum: true

  field :recording_device_type, 6,
    type: Google.Cloud.Speech.V1.RecognitionMetadata.RecordingDeviceType,
    enum: true

  field :recording_device_name, 7, type: :string
  field :original_mime_type, 8, type: :string
  field :audio_topic, 10, type: :string
end

defmodule Google.Cloud.Speech.V1.RecognitionMetadata.InteractionType do
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use Protobuf, enum: true, syntax: :proto3

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
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use Protobuf, enum: true, syntax: :proto3

  field :MICROPHONE_DISTANCE_UNSPECIFIED, 0
  field :NEARFIELD, 1
  field :MIDFIELD, 2
  field :FARFIELD, 3
end

defmodule Google.Cloud.Speech.V1.RecognitionMetadata.OriginalMediaType do
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use Protobuf, enum: true, syntax: :proto3

  field :ORIGINAL_MEDIA_TYPE_UNSPECIFIED, 0
  field :AUDIO, 1
  field :VIDEO, 2
end

defmodule Google.Cloud.Speech.V1.RecognitionMetadata.RecordingDeviceType do
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use Protobuf, enum: true, syntax: :proto3

  field :RECORDING_DEVICE_TYPE_UNSPECIFIED, 0
  field :SMARTPHONE, 1
  field :PC, 2
  field :PHONE_LINE, 3
  field :VEHICLE, 4
  field :OTHER_OUTDOOR_DEVICE, 5
  field :OTHER_INDOOR_DEVICE, 6
end

defmodule Google.Cloud.Speech.V1.SpeechContext do
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use Protobuf, syntax: :proto3


  field :phrases, 1, repeated: true, type: :string
end

defmodule Google.Cloud.Speech.V1.RecognitionAudio do
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use Protobuf, syntax: :proto3

  oneof :audio_source, 0
  field :content, 1, type: :bytes, oneof: 0
  field :uri, 2, type: :string, oneof: 0
end

defmodule Google.Cloud.Speech.V1.RecognizeResponse do
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use Protobuf, syntax: :proto3

  field :results, 2, repeated: true, type: Google.Cloud.Speech.V1.SpeechRecognitionResult
end

defmodule Google.Cloud.Speech.V1.LongRunningRecognizeResponse do
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use Protobuf, syntax: :proto3

  field :results, 2, repeated: true, type: Google.Cloud.Speech.V1.SpeechRecognitionResult
end

defmodule Google.Cloud.Speech.V1.LongRunningRecognizeMetadata do
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use Protobuf, syntax: :proto3

  field :progress_percent, 1, type: :int32
  field :start_time, 2, type: Google.Protobuf.Timestamp
  field :last_update_time, 3, type: Google.Protobuf.Timestamp
end

defmodule Google.Cloud.Speech.V1.StreamingRecognizeResponse do
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use Protobuf, syntax: :proto3

  field :error, 1, type: Google.Rpc.Status
  field :results, 2, repeated: true, type: Google.Cloud.Speech.V1.StreamingRecognitionResult

  field :speech_event_type, 4,
    type: Google.Cloud.Speech.V1.StreamingRecognizeResponse.SpeechEventType,
    enum: true
end

defmodule Google.Cloud.Speech.V1.StreamingRecognizeResponse.SpeechEventType do
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use Protobuf, enum: true, syntax: :proto3

  field :SPEECH_EVENT_UNSPECIFIED, 0
  field :END_OF_SINGLE_UTTERANCE, 1
end

defmodule Google.Cloud.Speech.V1.StreamingRecognitionResult do
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use Protobuf, syntax: :proto3

  field :alternatives, 1,
    repeated: true,
    type: Google.Cloud.Speech.V1.SpeechRecognitionAlternative

  field :is_final, 2, type: :bool
  field :stability, 3, type: :float
  field :result_end_time, 4, type: Google.Protobuf.Duration
  field :channel_tag, 5, type: :int32
  field :language_code, 6, type: :string
end

defmodule Google.Cloud.Speech.V1.SpeechRecognitionResult do
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use Protobuf, syntax: :proto3

  field :alternatives, 1,
    repeated: true,
    type: Google.Cloud.Speech.V1.SpeechRecognitionAlternative

  field :channel_tag, 2, type: :int32
end

defmodule Google.Cloud.Speech.V1.SpeechRecognitionAlternative do
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use Protobuf, syntax: :proto3

  field :transcript, 1, type: :string
  field :confidence, 2, type: :float
  field :words, 3, repeated: true, type: Google.Cloud.Speech.V1.WordInfo
end

defmodule Google.Cloud.Speech.V1.WordInfo do
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use Protobuf, syntax: :proto3

  field :start_time, 1, type: Google.Protobuf.Duration
  field :end_time, 2, type: Google.Protobuf.Duration
  field :word, 3, type: :string
end

defmodule Google.Cloud.Speech.V1.Speech.Service do
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use GRPC.Service, name: "google.cloud.speech.v1.Speech"

  rpc :Recognize,
      Google.Cloud.Speech.V1.RecognizeRequest,
      Google.Cloud.Speech.V1.RecognizeResponse

  rpc :LongRunningRecognize,
      Google.Cloud.Speech.V1.LongRunningRecognizeRequest,
      Google.Longrunning.Operation

  rpc :StreamingRecognize,
      stream(Google.Cloud.Speech.V1.StreamingRecognizeRequest),
      stream(Google.Cloud.Speech.V1.StreamingRecognizeResponse)
end

defmodule Google.Cloud.Speech.V1.Speech.Stub do
  @moduledoc "Auto-generated from `googleapis/google/cloud/speech/v1/cloud_speech.proto`"
  use GRPC.Stub, service: Google.Cloud.Speech.V1.Speech.Service
end
