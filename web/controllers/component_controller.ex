defmodule Healthlocker.ComponentController do
  use Healthlocker.Web, :controller
  alias Healthlocker.Post

  def index(conn, _params) do
    post = Post |> first |> Repo.one
    conn
    |> render("index.html", post: post)
  end
end
