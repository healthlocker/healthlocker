defmodule Healthlocker.PostController do
  use Healthlocker.Web, :controller
  alias Healthlocker.Post

  def show(conn, %{"id" => id}) do
    post = Repo.get!(Post, id) |> Repo.preload(:likes)
    conn
    |> render("show.html", post: post)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    conn
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    user_id = get_session(conn, :user_id)
    changeset = Post.changeset(%Post{}, post_params)
    changeset = Ecto.Changeset.put_change(changeset, :user_id, user_id)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        posts = Repo.all(Post)
        conn
        |> put_flash(:info, "Post created!")
        |> redirect(to: post_path(conn, :new, posts))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end

  def index(conn, _params) do
    posts =
      Post
      |> Post.find_stories
      |> Repo.all
      |> Enum.shuffle

    render(conn, "index.html", posts: posts)
  end

  def edit(conn, %{"id" => id}) do
    if conn.assigns.current_user.role == "admin" do
      post = Repo.get!(Post, id)
      changeset = Post.changeset(post)
      conn
      |> render("edit.html", post: post, changeset: changeset)
    else
      conn
      |> put_flash(:error, "You don't have permission to access that page")
      |> redirect(to: page_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Post
          |> Repo.get!(id)
          |> Repo.preload(:likes)
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, changeset} ->
        conn
        |> render("edit.html", post: post, changeset: changeset)
    end
  end

  def likes(conn, %{"post_id" => id}) do
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
end
