defmodule Healthlocker.PageController do
  use Healthlocker.Web, :controller
  alias Healthlocker.{Post, Product, TestRepo}

  def index(conn, _params) do
    query = from p in Product, where: p."ProductName" == "katbow"
    TestRepo.all(query)
    |> IO.inspect(label: "===> over here")
    featured_story = Post
                     |> Post.find_stories
                     |> Repo.all
    featured_tip = Post
                   |> Post.find_tips
                   |> Repo.all
    story = if Kernel.length(featured_story) < 1 do
      nil
    else
      featured_story |> Enum.random
    end

    tip = if Kernel.length(featured_tip) < 1 do
      nil
    else
      featured_tip |> Enum.random
    end
    render conn, "index.html", story: story, tip: tip
  end

  def show(conn, %{"id" => id}) do
    render conn, String.to_atom(id)
  end
end
