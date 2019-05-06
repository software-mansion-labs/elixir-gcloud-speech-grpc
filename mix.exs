defmodule GCloudSpeechGrpc.MixProject do
  use Mix.Project

  def project do
    [
      app: :gcloud_speech_grpc,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: []
    ]
  end

  defp deps do
    [
    {:protobuf, "~> 0.5.3"},
    # {:grpc, github: "elixir-grpc/grpc"}
    # Only for files generated from Google's protos.
    # Can be ignored if you don't use Google's protos.
    #{:google_protos, "~> 0.1"}
    ]
  end
end
