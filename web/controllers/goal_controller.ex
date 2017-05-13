defmodule Healthlocker.GoalController do
  use Healthlocker.Web, :controller
  alias Healthlocker.{Goal, Step}

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id
    important_goals = Goal
                     |> Goal.get_important_goals(user_id)
                     |> Repo.all
    unimportant_goals = Goal
                     |> Goal.get_unimportant_goals(user_id)
                     |> Repo.all
    all_goals = Enum.concat(important_goals, unimportant_goals)

    incomplete_goals = all_goals
                      |> Enum.filter(fn goal ->
                        !goal.completed
                      end)
    completed = Goal
              |> Goal.get_completed_goals(user_id)
              |> Repo.all

    if Kernel.length(all_goals) == 0 && Kernel.length(completed) do
      conn
      |> redirect(to: goal_path(conn, :new))
    else
      render conn, "index.html", goals: incomplete_goals, complete_goals: completed
    end
  end

  def new(conn, _params) do
    # Build up a collection of 5 associated steps.
    changeset = Goal.changeset(%Goal{
      steps: Enum.map(1..5, fn _ -> Step.changeset(%Step{}) end)
    })

    render(conn, "new.html", changeset: changeset)
  end

  def show(conn, %{"id" => id}) do
    user_id = conn.assigns.current_user.id
    goal = Goal
          |> Goal.get_goal_by_user(id, user_id)
          |> Repo.one!
    render conn, "show.html", goal: goal
  end

  def create(conn, %{"goal" => goal_params}) do
    content = get_content(goal_params)
    user_id = get_session(conn, :user_id)
    changeset = Goal.changeset(%Goal{}, content)
              |> Ecto.Changeset.put_change(:user_id, user_id)

    case Repo.insert(changeset) do
      {:ok, goal} ->
        conn |> track_created(goal)

        conn
        |> put_flash(:info, "Goal added!")
        |> redirect(to: goal_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user_id = conn.assigns.current_user.id
    goal = Goal
          |> Goal.get_goal_by_user(id, user_id)
          |> Repo.one
          |> Map.update!(:content, &(String.trim_trailing(&1, " #Goal")))
    changeset = Goal.changeset(goal)
    render(conn, "edit.html", goal: goal, changeset: changeset)
  end

  def update(conn, %{"id" => id, "goal" => goal_params}) do
    goal = Goal
      |> Repo.get!(id)
      |> Repo.preload(:steps)
    content = get_content(goal_params)
    changeset = Goal.changeset(goal, content)
              |> Goal.set_achieved_at()

    case Repo.update(changeset) do
      {:ok, _goal} ->
        conn
        |> put_flash(:info, "Goal updated successfully.")
        |> redirect(to: goal_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", goal: goal, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_id = conn.assigns.current_user.id
    goal = Goal
          |> Goal.get_goal_by_user(id, user_id)
          |> Repo.one

    Repo.delete!(goal)

    conn
    |> put_flash(:info, "Goal deleted successfully.")
    |> redirect(to: goal_path(conn, :index))
  end

  def get_content(params) do
    if Map.has_key?(params, "content") && params["content"] != "" do
      Map.update(params, "content", params["content"], &(&1 <> " #Goal"))
    else
      params
    end
  end

  defp track_created(conn, %Goal{} = goal) do
    Healthlocker.Analytics.track(conn.assigns.current_user, :create, goal)
  end
end
