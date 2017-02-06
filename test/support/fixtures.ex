defmodule Healthlocker.Fixtures do
  alias Healthlocker.Repo
  alias Healthlocker.User
end

def fixture(:user) do
  Repo.insert %User{email: "user@example.com", password: "password123"}
end
