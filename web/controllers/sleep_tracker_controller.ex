defmodule Healthlocker.SleepTrackerController do
  use Healthlocker.Web, :controller

  plug :authenticate
  alias Healthlocker.SleepTracker
  use Timex

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id
    sleep_data = SleepTracker
                |> SleepTracker.get_sleep_data(user_id)
                |> Repo.all

    date = Date.to_iso8601(Date.utc_today())

    render(conn, "index.html", sleep_data: sleep_data, date: date)
  end

  def prev_date(conn, %{"sleep_tracker_id" => end_date}) do

    user_id = conn.assigns.current_user.id
    sleep_data = SleepTracker
                |> SleepTracker.get_sleep_data(user_id)
                |> Repo.all

    # need to go back & forth with iso dates for display purposes. An elixir
    # date won't render on the page, and iso dates can't be used with timex for
    # shifting back 7 days
    {:ok, iex_date} = Date.from_iso8601(end_date)
    date = Date.to_iso8601(Timex.shift(iex_date, days: -7))

    render(conn, "index.html", sleep_data: sleep_data, date: date)
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
