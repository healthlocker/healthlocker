defmodule Healthlocker.CopingStrategyController do
  use Healthlocker.Web, :controller

  alias Healthlocker.Post

  def index(conn, _params) do
    coping_strategies = Post
                        |> Post.get_coping_strategies
                        |> Repo.all
    render conn, "index.html", coping_strategies: coping_strategies
  end

  def new(conn, _params) do
    changeset =  Post.changeset(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def show(conn, %{"id" => id}) do
    coping_strategy = Repo.get!(Post, id)
    render conn, "show.html", coping_strategy: coping_strategy
  end

  def create(conn, %{"post" => coping_strategy_params}) do
    content = %{"content" => coping_strategy_params["content"] <> " #CopingStrategy"}
    user_id = get_session(conn, :user_id)
    changeset = Post.changeset(%Post{}, content)
    changeset = Ecto.Changeset.put_change(changeset, :user_id, user_id)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Coping strategy added!")
        |> redirect(to: toolkit_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    coping_strategy = Repo.get!(Post, id)
                      |> Map.update!(:content, &(String.trim_trailing(&1, " #CopingStrategy")))

    changeset = Post.changeset(coping_strategy)
    render(conn, "edit.html", coping_strategy: coping_strategy, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => coping_strategy_params}) do
    coping_strategy = Repo.get!(Post, id)
    content = %{"content" => coping_strategy_params["content"] <> " #CopingStrategy"}
    changeset = Post.changeset(coping_strategy, content)

    case Repo.update(changeset) do
      {:ok, coping_strategy} ->
        conn
        |> put_flash(:info, "Coping strategy updated successfully.")
        |> redirect(to: coping_strategy_path(conn, :show, coping_strategy))
      {:error, changeset} ->
        render(conn, "edit.html", coping_strategy: coping_strategy, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    coping_strategy = Repo.get!(Post, id)

    Repo.delete!(coping_strategy)

    conn
    |> put_flash(:info, "Coping strategy deleted successfully.")
    |> redirect(to: coping_strategy_path(conn, :index))
  end
end
