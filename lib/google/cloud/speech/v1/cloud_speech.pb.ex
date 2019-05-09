defmodule Google.Cloud.Speech.V1.RecognizeRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          config: Google.Cloud.Speech.V1.RecognitionConfig.t() | nil,
          audio: Google.Cloud.Speech.V1.RecognitionAudio.t() | nil
        }
  defstruct [:config, :audio]

  field :config, 1, type: Google.Cloud.Speech.V1.RecognitionConfig
  field :audio, 2, type: Google.Cloud.Speech.V1.RecognitionAudio
end

defmodule Google.Cloud.Speech.V1.LongRunningRecognizeRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          config: Google.Cloud.Speech.V1.RecognitionConfig.t() | nil,
          audio: Google.Cloud.Speech.V1.RecognitionAudio.t() | nil
        }
  defstruct [:config, :audio]

  field :config, 1, type: Google.Cloud.Speech.V1.RecognitionConfig
  field :audio, 2, type: Google.Cloud.Speech.V1.RecognitionAudio
end

defmodule Google.Cloud.Speech.V1.StreamingRecognizeRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          streaming_request: {atom, any}
        }
  defstruct [:streaming_request]

  oneof :streaming_request, 0
  field :streaming_config, 1, type: Google.Cloud.Speech.V1.StreamingRecognitionConfig, oneof: 0
  field :audio_content, 2, type: :bytes, oneof: 0
end

defmodule Google.Cloud.Speech.V1.StreamingRecognitionConfig do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          config: Google.Cloud.Speech.V1.RecognitionConfig.t() | nil,
          single_utterance: boolean,
          interim_results: boolean
        }
  defstruct [:config, :single_utterance, :interim_results]

  field :config, 1, type: Google.Cloud.Speech.V1.RecognitionConfig
  field :single_utterance, 2, type: :bool
  field :interim_results, 3, type: :bool
end

defmodule Google.Cloud.Speech.V1.RecognitionConfig do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          encoding: atom | integer,
          sample_rate_hertz: integer,
          audio_channel_count: integer,
          enable_separate_recognition_per_channel: boolean,
          language_code: String.t(),
          max_alternatives: integer,
          profanity_filter: boolean,
          speech_contexts: [Google.Cloud.Speech.V1.SpeechContext.t()],
          enable_word_time_offsets: boolean,
          enable_automatic_punctuation: boolean,
          model: String.t(),
          use_enhanced: boolean
        }
  defstruct [
    :encoding,
    :sample_rate_hertz,
    :audio_channel_count,
    :enable_separate_recognition_per_channel,
    :language_code,
    :max_alternatives,
    :profanity_filter,
    :speech_contexts,
    :enable_word_time_offsets,
    :enable_automatic_punctuation,
    :model,
    :use_enhanced
  ]

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
  field :model, 13, type: :string
  field :use_enhanced, 14, type: :bool
end

defmodule Google.Cloud.Speech.V1.RecognitionConfig.AudioEncoding do
  @moduledoc false
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

defmodule Google.Cloud.Speech.V1.SpeechContext do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          phrases: [String.t()]
        }
  defstruct [:phrases]

  field :phrases, 1, repeated: true, type: :string
end

defmodule Google.Cloud.Speech.V1.RecognitionAudio do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          audio_source: {atom, any}
        }
  defstruct [:audio_source]

  oneof :audio_source, 0
  field :content, 1, type: :bytes, oneof: 0
  field :uri, 2, type: :string, oneof: 0
end

defmodule Google.Cloud.Speech.V1.RecognizeResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          results: [Google.Cloud.Speech.V1.SpeechRecognitionResult.t()]
        }
  defstruct [:results]

  field :results, 2, repeated: true, type: Google.Cloud.Speech.V1.SpeechRecognitionResult
end

defmodule Google.Cloud.Speech.V1.LongRunningRecognizeResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          results: [Google.Cloud.Speech.V1.SpeechRecognitionResult.t()]
        }
  defstruct [:results]

  field :results, 2, repeated: true, type: Google.Cloud.Speech.V1.SpeechRecognitionResult
end

defmodule Google.Cloud.Speech.V1.LongRunningRecognizeMetadata do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          progress_percent: integer,
          start_time: Google.Protobuf.Timestamp.t() | nil,
          last_update_time: Google.Protobuf.Timestamp.t() | nil
        }
  defstruct [:progress_percent, :start_time, :last_update_time]

  field :progress_percent, 1, type: :int32
  field :start_time, 2, type: Google.Protobuf.Timestamp
  field :last_update_time, 3, type: Google.Protobuf.Timestamp
end

defmodule Google.Cloud.Speech.V1.StreamingRecognizeResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          error: Google.Rpc.Status.t() | nil,
          results: [Google.Cloud.Speech.V1.StreamingRecognitionResult.t()],
          speech_event_type: atom | integer
        }
  defstruct [:error, :results, :speech_event_type]

  field :error, 1, type: Google.Rpc.Status
  field :results, 2, repeated: true, type: Google.Cloud.Speech.V1.StreamingRecognitionResult

  field :speech_event_type, 4,
    type: Google.Cloud.Speech.V1.StreamingRecognizeResponse.SpeechEventType,
    enum: true
end

defmodule Google.Cloud.Speech.V1.StreamingRecognizeResponse.SpeechEventType do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field :SPEECH_EVENT_UNSPECIFIED, 0
  field :END_OF_SINGLE_UTTERANCE, 1
end

defmodule Google.Cloud.Speech.V1.StreamingRecognitionResult do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          alternatives: [Google.Cloud.Speech.V1.SpeechRecognitionAlternative.t()],
          is_final: boolean,
          stability: float,
          channel_tag: integer
        }
  defstruct [:alternatives, :is_final, :stability, :channel_tag]

  field :alternatives, 1,
    repeated: true,
    type: Google.Cloud.Speech.V1.SpeechRecognitionAlternative

  field :is_final, 2, type: :bool
  field :stability, 3, type: :float
  field :channel_tag, 5, type: :int32
end

defmodule Google.Cloud.Speech.V1.SpeechRecognitionResult do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          alternatives: [Google.Cloud.Speech.V1.SpeechRecognitionAlternative.t()],
          channel_tag: integer
        }
  defstruct [:alternatives, :channel_tag]

  field :alternatives, 1,
    repeated: true,
    type: Google.Cloud.Speech.V1.SpeechRecognitionAlternative

  field :channel_tag, 2, type: :int32
end

defmodule Google.Cloud.Speech.V1.SpeechRecognitionAlternative do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          transcript: String.t(),
          confidence: float,
          words: [Google.Cloud.Speech.V1.WordInfo.t()]
        }
  defstruct [:transcript, :confidence, :words]

  field :transcript, 1, type: :string
  field :confidence, 2, type: :float
  field :words, 3, repeated: true, type: Google.Cloud.Speech.V1.WordInfo
end

defmodule Google.Cloud.Speech.V1.WordInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          start_time: Google.Protobuf.Duration.t() | nil,
          end_time: Google.Protobuf.Duration.t() | nil,
          word: String.t()
        }
  defstruct [:start_time, :end_time, :word]

  field :start_time, 1, type: Google.Protobuf.Duration
  field :end_time, 2, type: Google.Protobuf.Duration
  field :word, 3, type: :string
end

defmodule Google.Cloud.Speech.V1.Speech.Service do
  @moduledoc false
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
  @moduledoc false
  use GRPC.Stub, service: Google.Cloud.Speech.V1.Speech.Service
end
