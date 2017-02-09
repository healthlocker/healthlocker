defmodule Healthlocker.TestHelpers do
  alias Healthlocker.Repo
  alias Healthlocker.User

  def insert_user() do
    changes = %{
      email: "me@example.com",
      password: "abc123",
      name: "MyName",
      security_question: "Favourite animal?",
      security_answer: "Cat",
      data_access: true,
      role: "service user"
    }

    %User{}
    |> User.registration_changeset(changes)
    |> Repo.insert()
  end
end
