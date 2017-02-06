defmodule Healthlocker.PageController do
  use Healthlocker.Web, :controller

  alias Healthlocker.Post

  def index(conn, _params) do
    featured_story = Post
                     |> Post.find_stories
                     |> Repo.one
    featured_tip = Post
                   |> Post.find_tips
                   |> Repo.one
    render conn, "index.html", story: featured_story, tip: featured_tip
  end
end
