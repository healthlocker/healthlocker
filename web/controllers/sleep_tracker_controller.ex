defmodule Healthlocker.SleepTrackerController do
  use Healthlocker.Web, :controller

  plug :authenticate
  alias Healthlocker.SleepTracker

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id
    sleep_data = SleepTracker
                |> SleepTracker.get_sleep_data(user_id)
                |> Repo.all

    sleep_today = SleepTracker
                |> SleepTracker.get_sleep_data_today(user_id)
                |> Repo.all
                |> List.first()
    render(conn, "index.html", sleep_data: sleep_data, sleep_today: sleep_today)
  end

  def new(conn, _params) do
    changeset = SleepTracker.changeset(%SleepTracker{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"sleep_tracker" => st_params}) do
    user = conn.assigns.current_user
    changeset = SleepTracker.changeset(%SleepTracker{}, st_params)
              |> Ecto.Changeset.put_assoc(:user, user)
              |> Ecto.Changeset.put_change(:for_date, Date.utc_today())

    case Repo.insert(changeset) do
      {:ok, _params} ->
        conn
        |> put_flash(:info, "Sleep tracked successfully!")
        |> redirect(to: toolkit_path(conn, :index))
      {:error, changeset} ->
        if String.contains?(elem(changeset.errors[:for_date], 0),
          "You can only enter sleep once per day.") do
            conn
            |> put_flash(:error, "You can only enter sleep once per day.")
            |> render("new.html", changeset: changeset)
          else
            render(conn, "new.html", changeset: changeset)
          end
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
