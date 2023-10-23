defmodule Google.Protobuf.Any do
  @moduledoc "Auto-generated from `googleapis/google/protobuf/any.proto`"
  use Protobuf, syntax: :proto3

  field :type_url, 1, type: :string
  field :value, 2, type: :bytes
end
