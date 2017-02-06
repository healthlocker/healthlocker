defmodule Healthlocker.TestHelpers do
  alias Healthlocker.Repo
  alias Healthlocker.User

  def insert_user(attrs \\%{}) do
    changes = Dict.merge(%{
      email: "user#{Base.encode16(:crypto.rand_bytes(8))}",
      password: "password"
    }, attrs)

    %User{}
    |> User.registration_changeset(changes)
    |> Repo.insert()
  end
end
