#!/bin/bash

rm -rf lib/google

PROTOS="\
  google/cloud/speech/v1/cloud_speech.proto \
  google/longrunning/operations.proto \
  google/rpc/status.proto \
  google/rpc/code.proto \
  google/protobuf/any.proto \
  google/protobuf/duration.proto \
  google/protobuf/empty.proto \
  google/protobuf/struct.proto \
  google/protobuf/timestamp.proto \
  google/protobuf/wrappers.proto \
"

protoc -I ./googleapis --elixir_out=plugins=grpc:./lib $PROTOS
