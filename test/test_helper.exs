ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(Healthlocker.Repo, :manual)
Ecto.Adapters.SQL.Sandbox.mode(Healthlocker.ReadOnlyRepo, :manual)


{:ok, _} = Application.ensure_all_started(:wallaby)
Application.put_env(:wallaby, :base_url, "http://localhost:4001")

Application.put_env(:wallaby, :screenshot_on_failure, true)
