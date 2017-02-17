defmodule Healthlocker.CopingStrategyController do
  use Healthlocker.Web, :controller

  alias Healthlocker.Post

  def new(conn, _params) do
    changeset =  Post.changeset(%Post{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"post" => coping_strategy_params}) do
    content = %{"content" => coping_strategy_params["content"] <> " #CopingStrategy"}
    user_id = get_session(conn, :user_id)
    changeset = Post.changeset(%Post{}, content)
    changeset = Ecto.Changeset.put_change(changeset, :user_id, user_id)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        posts = Repo.all(Post)
        conn
        |> put_flash(:info, "Coping strategy added!")
        |> redirect(to: toolkit_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
