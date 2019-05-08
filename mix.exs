defmodule ExGCloudSpeech.MixProject do
  use Mix.Project

  @version "0.1.0"
  @github_url "https://github.com/SoftwareMansion/elixir-gcp-speech"

  def project do
    [
      app: :elixir_gcp_speech,
      version: @version,
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # hex
      description: "Elixir client for Google Cloud Speech-to-Text API using gRPC",
      package: package(),

      # docs
      name: "Elixir GCP Speech",
      source_url: @github_url,
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: []
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:goth, "~> 1.0"},
      {:protobuf, "~> 0.6.1"},
      {:grpc, "~> 0.3.1"}
    ]
  end

  defp package do
    [
      maintainers: ["Bartosz Błaszków"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => @github_url
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      source_ref: "v#{@version}"
    ]
  end
end
