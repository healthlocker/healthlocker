defmodule Healthlocker.PageController do
  use Healthlocker.Web, :controller

  alias Healthlocker.Post

  def index(conn, _params) do
    featured_story = Post
                     |> Post.find_single_story
                     |> Repo.one
    featured_tip = Post
                   |> Post.find_single_tip
                   |> Repo.one
    render conn, "index.html", story: featured_story, tip: featured_tip
  end

  def about(conn, _params) do
    render conn, "about.html"
  end

  def privacy(conn, _params) do
    render conn, "privacy.html"
  end

  def terms(conn, _params) do
    render conn, "terms.html"
  end
end
