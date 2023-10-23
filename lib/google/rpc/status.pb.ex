defmodule Google.Rpc.Status do
  @moduledoc "Auto-generated from `googleapis/google/rpc/status.proto`"
  use Protobuf, syntax: :proto3

  defstruct [:code, :message, :details]

  field :code, 1, type: :int32
  field :message, 2, type: :string
  field :details, 3, repeated: true, type: Google.Protobuf.Any
end
