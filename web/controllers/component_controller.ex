defmodule Healthlocker.ComponentController do
  use Healthlocker.Web, :controller
  alias Healthlocker.Post

  def index(conn, _params) do
    post = Post |> first |> Repo.one
    render conn, "index.html", post: post
  end
end
