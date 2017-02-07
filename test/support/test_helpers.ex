defmodule Healthlocker.TestHelpers do
  alias Healthlocker.Repo
  alias Healthlocker.User

  def insert_user() do
    changes = %{
      email: "user@example.com",
      password: "password"
    }

    %User{}
    |> User.registration_changeset(changes)
    |> Repo.insert()
  end
end
