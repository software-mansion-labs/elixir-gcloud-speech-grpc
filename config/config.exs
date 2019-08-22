use Mix.Config

creds_path = Path.expand("./creds.json", __DIR__)

if creds_path |> File.exists?() do
  config :goth, json: creds_path |> File.read!()
else
  config :goth, disabled: true
end
