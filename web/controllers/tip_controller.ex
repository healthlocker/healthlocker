defmodule Healthlocker.TipController do
  use Healthlocker.Web, :controller

  alias Healthlocker.Post

  def index(conn, params) do
    tips = if params["tag"] do
            Post |> Post.find_tags(params) |> Repo.all
          else
            Post |> Post.find_tips |> Repo.all
          end
    conn
    |> render("index.html", posts: tips)
  end

end
