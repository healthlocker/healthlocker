defmodule Healthlocker.TipController do
  use Healthlocker.Web, :controller

  alias Healthlocker.Post

  def index(conn, params) do
    tips = if params["tag"] do
            Repo.all(from p in Post, where: ilike(p.content, ^"%##{params["tag"]}%"))
          else
            Repo.all(from p in Post, where: ilike(p.content, "%#tip%"))
          end
    render(conn, "index.html", posts: tips)
  end

end
