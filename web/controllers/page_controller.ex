defmodule Healthlocker.PageController do
  use Healthlocker.Web, :controller

  alias Healthlocker.Post

  def index(conn, _params) do
    featured_story = Repo.one from p in Post,
                              limit: 1,
                              where: ilike(p.content, "%#story%")
    featured_tip = Repo.one from p in Post,
                              limit: 1,
                              where: ilike(p.content, "%#tip%")
    render conn, "index.html", story: featured_story, tip: featured_tip
  end
end
