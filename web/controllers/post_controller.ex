defmodule Healthlocker.PostController do
  use Healthlocker.Web, :controller

  alias Healthlocker.Post

  def show(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    render conn, "show.html", post: post
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"post" => post_params}) do
    changeset = Post.changeset(%Post{}, post_params)
    {:ok, post} = Repo.insert(changeset)

    posts = Repo.all(Post)

    conn
    |> put_flash(:info, "Post created!")
    |> redirect(to: post_path(conn, :index, posts))
  end

  def index(conn, _params) do
    posts = Repo.all(Post)
    render(conn, "index.html", posts: posts)
  end
end
