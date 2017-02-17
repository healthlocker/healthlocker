defmodule Healthlocker.ToolkitController do
  use Healthlocker.Web, :controller

  alias Healthlocker.Post

  def index(conn, _params) do
    coping_strategies = Post
                        |> Post.get_coping_strategies
                        |> Repo.all
    render conn, "index.html", coping_strategies: coping_strategies
  end
end
