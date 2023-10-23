defmodule Google.Longrunning.Operation do
  @moduledoc "Auto-generated from `googleapis/google/longrunning/operations.proto`"
  use Protobuf, syntax: :proto3

  oneof :result, 0
  field :name, 1, type: :string
  field :metadata, 2, type: Google.Protobuf.Any
  field :done, 3, type: :bool
  field :error, 4, type: Google.Rpc.Status, oneof: 0
  field :response, 5, type: Google.Protobuf.Any, oneof: 0
end

defmodule Google.Longrunning.GetOperationRequest do
  @moduledoc "Auto-generated from `googleapis/google/longrunning/operations.proto`"
  use Protobuf, syntax: :proto3

  field :name, 1, type: :string
end

defmodule Google.Longrunning.ListOperationsRequest do
  @moduledoc "Auto-generated from `googleapis/google/longrunning/operations.proto`"
  use Protobuf, syntax: :proto3

  field :name, 4, type: :string
  field :filter, 1, type: :string
  field :page_size, 2, type: :int32
  field :page_token, 3, type: :string
end

defmodule Google.Longrunning.ListOperationsResponse do
  @moduledoc "Auto-generated from `googleapis/google/longrunning/operations.proto`"
  use Protobuf, syntax: :proto3

  field :operations, 1, repeated: true, type: Google.Longrunning.Operation
  field :next_page_token, 2, type: :string
end

defmodule Google.Longrunning.CancelOperationRequest do
  @moduledoc "Auto-generated from `googleapis/google/longrunning/operations.proto`"
  use Protobuf, syntax: :proto3

  field :name, 1, type: :string
end

defmodule Google.Longrunning.DeleteOperationRequest do
  @moduledoc "Auto-generated from `googleapis/google/longrunning/operations.proto`"
  use Protobuf, syntax: :proto3

  field :name, 1, type: :string
end

defmodule Google.Longrunning.WaitOperationRequest do
  @moduledoc "Auto-generated from `googleapis/google/longrunning/operations.proto`"
  use Protobuf, syntax: :proto3

  field :name, 1, type: :string
  field :timeout, 2, type: Google.Protobuf.Duration
end

defmodule Google.Longrunning.OperationInfo do
  @moduledoc "Auto-generated from `googleapis/google/longrunning/operations.proto`"
  use Protobuf, syntax: :proto3

  field :response_type, 1, type: :string
  field :metadata_type, 2, type: :string
end

defmodule Google.Longrunning.Operations.Service do
  @moduledoc "Auto-generated from `googleapis/google/longrunning/operations.proto`"
  use GRPC.Service, name: "google.longrunning.Operations"

  rpc :ListOperations,
      Google.Longrunning.ListOperationsRequest,
      Google.Longrunning.ListOperationsResponse

  rpc :GetOperation, Google.Longrunning.GetOperationRequest, Google.Longrunning.Operation
  rpc :DeleteOperation, Google.Longrunning.DeleteOperationRequest, Google.Protobuf.Empty
  rpc :CancelOperation, Google.Longrunning.CancelOperationRequest, Google.Protobuf.Empty
  rpc :WaitOperation, Google.Longrunning.WaitOperationRequest, Google.Longrunning.Operation
end

defmodule Google.Longrunning.Operations.Stub do
  @moduledoc "Auto-generated from `googleapis/google/longrunning/operations.proto`"
  use GRPC.Stub, service: Google.Longrunning.Operations.Service
end
