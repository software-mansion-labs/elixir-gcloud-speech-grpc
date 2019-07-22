use Mix.Config

config :goth, json: Path.expand("./creds.json", __DIR__) |> File.read!()
