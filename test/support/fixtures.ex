defmodule Healthlocker.Fixtures do
  alias Healthlocker.Repo
  alias Healthlocker.Post
  alias Healthlocker.User

  def fixture(:user) do
    Repo.insert %User{email: "user@example.com", password: "password123"}
  end

  def fixture(:post) do
    Repo.insert %Post{content: "#Title for content This is a text for a story #story"}
    Repo.insert %Post{content: "Here's a tip #tip #connect"}
  end
end
