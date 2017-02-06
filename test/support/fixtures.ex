defmodule Healthlocker.Fixtures do
  alias Healthlocker.Repo
  alias Healthlocker.Post

  def fixture(:post) do
    Repo.insert %Post{content: "#Title for content This is a text for a story #story"}
    Repo.insert %Post{content: "Here's a tip #tip #connect"}
  end
end
