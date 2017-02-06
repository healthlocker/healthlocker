defmodule Healthlocker.PageController do
  use Healthlocker.Web, :controller

  alias Healthlocker.Post

  def index(conn, _params) do
    featured_story = Post
                     |> Post.featured_story
                     |> Repo.one
    featured_tip = Post
                   |> Post.featured_tip
                   |> Repo.one
    render conn, "index.html", story: featured_story, tip: featured_tip
  end
end
