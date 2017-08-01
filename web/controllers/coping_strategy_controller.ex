defmodule Healthlocker.CopingStrategyController do
  use Healthlocker.Web, :controller
  alias Healthlocker.Post

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id
    coping_strategies = Post
                        |> Post.get_coping_strategies(user_id)
                        |> Repo.all
    if Kernel.length(coping_strategies) == 0 do
      conn
      |> redirect(to: coping_strategy_path(conn, :new))
    else
      conn
      |> Healthlocker.SetView.set_view("CopingStrategyView")
      |> render("index.html", coping_strategies: coping_strategies)
    end
  end

  def new(conn, _params) do
    changeset =  Post.changeset(%Post{})
    conn
    |> Healthlocker.SetView.set_view("CopingStrategyView")
    |> render("new.html", changeset: changeset)
  end

  def show(conn, %{"id" => id}) do
    user_id = conn.assigns.current_user.id
    coping_strategy = Post
                      |> Post.get_coping_strategy_by_user(id, user_id)
                      |> Repo.one!
    conn
    |> Healthlocker.SetView.set_view("CopingStrategyView")
    |> render("show.html", coping_strategy: coping_strategy)
  end

  def create(conn, %{"post" => coping_strategy_params}) do
    content = get_content(coping_strategy_params)
    user_id = get_session(conn, :user_id)
    changeset = Post.changeset(%Post{}, content)
    changeset = Ecto.Changeset.put_change(changeset, :user_id, user_id)

    case Repo.insert(changeset) do
      {:ok, post} ->
        conn |> track_created(post)
        conn
        |> put_flash(:info, "Coping strategy added!")
        |> redirect(to: coping_strategy_path(conn, :index))
      {:error, changeset} ->
        conn
        |> Healthlocker.SetView.set_view("CopingStrategyView")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user_id = conn.assigns.current_user.id
    coping_strategy = Post
                      |> Post.get_coping_strategy_by_user(id, user_id)
                      |> Repo.one
                      |> Map.update!(:content, &(String.trim_trailing(&1, " #CopingStrategy")))
    changeset = Post.changeset(coping_strategy)
    conn
    |> Healthlocker.SetView.set_view("CopingStrategyView")
    |> render("edit.html", coping_strategy: coping_strategy, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => coping_strategy_params}) do
    coping_strategy = Repo.get!(Post, id)
    content = get_content(coping_strategy_params)
    changeset = Post.changeset(coping_strategy, content)

    case Repo.update(changeset) do
      {:ok, coping_strategy} ->
        conn
        |> put_flash(:info, "Coping strategy updated successfully.")
        |> redirect(to: coping_strategy_path(conn, :show, coping_strategy))
      {:error, changeset} ->
        conn
        |> Healthlocker.SetView.set_view("CopingStrategyView")
        |> render("edit.html", coping_strategy: coping_strategy, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_id = conn.assigns.current_user.id
    coping_strategy = Post
                      |> Post.get_coping_strategy_by_user(id, user_id)
                      |> Repo.one

    Repo.delete!(coping_strategy)

    conn
    |> put_flash(:info, "Coping strategy deleted successfully.")
    |> redirect(to: coping_strategy_path(conn, :index))
  end

  def get_content(params) do
    if Map.has_key?(params, "content") && params["content"] != "" do
      %{"content" => params["content"] <> " #CopingStrategy"}
    else
      params
    end
  end

  defp track_created(conn, %Post{} = coping_strategy) do
    Healthlocker.Analytics.track(conn.assigns.current_user, :create, coping_strategy)
  end
end
