defmodule Healthlocker.GoalController do
  use Healthlocker.Web, :controller

  plug :authenticate

  alias Healthlocker.Post

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id
    goals = Post
           |> Post.get_goals(user_id)
           |> Repo.all
    render conn, "index.html", goals: goals
  end

  def new(conn, _params) do
    changeset =  Post.changeset(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def show(conn, %{"id" => id}) do
    user_id = conn.assigns.current_user.id
    goal = Post
          |> Post.get_goal_by_user(id, user_id)
          |> Repo.one!
    render conn, "show.html", goal: goal
  end

  def create(conn, %{"post" => goal_params}) do
    content = get_content(goal_params)
    user_id = get_session(conn, :user_id)
    changeset = Post.changeset(%Post{}, content)
    changeset = Ecto.Changeset.put_change(changeset, :user_id, user_id)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Goal added!")
        |> redirect(to: goal_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user_id = conn.assigns.current_user.id
    goal = Post
          |> Post.get_goal_by_user(id, user_id)
          |> Repo.one
          |> Map.update!(:content, &(String.trim_trailing(&1, " #Goal")))
    changeset = Post.changeset(goal)
    render(conn, "edit.html", goal: goal, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => goal_params}) do
    goal = Repo.get!(Post, id)
    content = get_content(goal_params)
    changeset = Post.changeset(goal, content)

    case Repo.update(changeset) do
      {:ok, goal} ->
        conn
        |> put_flash(:info, "Goal updated successfully.")
        |> redirect(to: goal_path(conn, :show, goal))
      {:error, changeset} ->
        render(conn, "edit.html", goal: goal, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_id = conn.assigns.current_user.id
    goal = Post
          |> Post.get_goal_by_user(id, user_id)
          |> Repo.one

    Repo.delete!(goal)

    conn
    |> put_flash(:info, "Goal deleted successfully.")
    |> redirect(to: goal_path(conn, :index))
  end

  def get_content(params) do
    if Map.has_key?(params, "content") && params["content"] != "" do
      %{"content" => params["content"] <> " #Goal"}
    else
      params
    end
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error,  "You must be logged in to access that page!")
      |> redirect(to: login_path(conn, :index))
      |> halt()
    end
  end
end
