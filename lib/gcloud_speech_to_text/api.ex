defmodule GCloudSpeechToText.API do
  @api_url "speech.googleapis.com"
  @api_port 443
  @token_scope "https://www.googleapis.com/auth/cloud-platform"

  @doc """
  Connects to a Google Cloud Speech-to-Text API
  """
  def connect() do
    cred = GRPC.Credential.new(ssl: [cacerts: :certifi.cacerts()])
    gun_opts = %{http2_opts: %{keepalive: :infinity}}

    with {:ok, channel} <-
           GRPC.Stub.connect(@api_url, @api_port, cred: cred, adapter_opts: gun_opts) do
      {:ok, channel}
    end
  end

  @doc """
  returns a list of options that need to be passed to a Service Stub when making a gRPC call
  """
  def request_opts() do
    [
      metadata: authorization_header(),
      content_type: "application/grpc",
      timeout: :infinity
    ]
  end

  defp authorization_header do
    with {:ok, token} <- Goth.Token.for_scope(@token_scope) do
      %{"authorization" => "#{token.type} #{token.token}"}
    end
  end

  @doc """
  Disconnects from Google Cloud Speech-to-Text API
  """
  defdelegate disconnect(channel), to: GRPC.Stub
end
