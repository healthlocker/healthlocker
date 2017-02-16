defmodule Healthlocker.PostController do
  use Healthlocker.Web, :controller

plug :authenticate when action in [:new, :create]

  alias Healthlocker.Post

  def show(conn, %{"id" => id}) do
    post = Repo.get!(Post, id) |> Repo.preload(:likes)
    render conn, "show.html", post: post
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"post" => post_params}) do
    changeset = Post.changeset(%Post{}, post_params)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        posts = Repo.all(Post)
        conn
        |> put_flash(:info, "Post created!")
        |> redirect(to: post_path(conn, :new, posts))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def index(conn, _params) do
    posts = Post |> Post.find_stories |> Repo.all
    render(conn, "index.html", posts: posts)
  end

  def likes(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    post = Repo.get!(Post, id)
    post
    |> Repo.preload(:likes)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:likes, [user])
    |> Repo.update
    find_redirect_path(conn)
  end

  def find_redirect_path(conn) do
    if conn |> get_req_header("referer") |> List.first do
      previous_path = conn
                      |> get_req_header("referer")
                      |> List.first
                      |> String.split("/")
                      |> List.last
      conn |> redirect(to: ("/" <> previous_path))
    else
      conn |> redirect(to: "/")
    end
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error,  "You must be logged in to access that page!")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
