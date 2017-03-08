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

  def show(conn, %{"id" => id}) do
    render conn, String.to_atom(id)
  end
end
