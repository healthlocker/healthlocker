use Mix.Config

config :appsignal, :config,
  active: true,
  name: "Healthlocker",
  push_api_key: System.get_env("APPSIGNAL_PUSH_API_KEY")
