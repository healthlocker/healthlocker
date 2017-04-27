defmodule Healthlocker.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL

      alias Healthlocker.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import Healthlocker.Router.Helpers
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Healthlocker.Repo)
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Healthlocker.ReadOnlyRepo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Healthlocker.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Healthlocker.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end
