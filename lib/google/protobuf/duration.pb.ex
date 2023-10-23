defmodule Google.Protobuf.Duration do
  @moduledoc "Auto-generated from `googleapis/google/protobuf/duration.proto`"
  use Protobuf, syntax: :proto3

  field :seconds, 1, type: :int64
  field :nanos, 2, type: :int32
end
