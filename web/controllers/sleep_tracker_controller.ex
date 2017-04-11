defmodule Healthlocker.SleepTrackerController do
  use Healthlocker.Web, :controller

  plug :authenticate
  alias Healthlocker.SleepTracker
  use Timex

  def get_sleep(conn, date) do
    user_id = conn.assigns.current_user.id
    SleepTracker
      |> SleepTracker.get_sleep_data(user_id, date)
      |> Repo.all
  end

  def index(conn, _params) do
    sleep_data = get_sleep(conn, Date.utc_today())

    date = Date.to_iso8601(Date.utc_today())

    render(conn, "index.html", sleep_data: sleep_data, date: date)
  end

  def prev_date(conn, %{"sleep_tracker_id" => end_date}) do
    # need to go back & forth with iso dates for display purposes. An elixir
    # date won't render on the page, and iso dates can't be used with timex for
    # shifting back 7 days
    {:ok, iex_date} = Date.from_iso8601(end_date)
    shifted_date = Timex.shift(iex_date, days: -7)
    date = Date.to_iso8601(shifted_date)

    sleep_data = get_sleep(conn, shifted_date)

    render(conn, "index.html", sleep_data: sleep_data, date: date)
  end

  def next_date(conn, %{"sleep_tracker_id" => end_date}) do
    # need to go back & forth with iso dates for display purposes. An elixir
    # date won't render on the page, and iso dates can't be used with timex for
    # shifting back 7 days
    {:ok, iex_date} = Date.from_iso8601(end_date)
    shifted_date = Timex.shift(iex_date, days: 7)
    date = Date.to_iso8601(shifted_date)

    sleep_data = get_sleep(conn, shifted_date)

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
    # if user has for_date already, put_flash & redirect for Can only enter data once per day

    sleep_data = SleepTracker
                |> SleepTracker.get_sleep_data_today(user.id)
                |> Repo.one

    if sleep_data do
      conn
      |> put_flash(:error, "You can only enter sleep once per day.")
      |> redirect(to: toolkit_path(conn, :index))
    else
      case Repo.insert(changeset) do
        {:ok, params} ->
          conn |> track_created(params)
          conn
          |> put_flash(:info, "Sleep tracked successfully!")
          |> redirect(to: toolkit_path(conn, :index))
        {:error, changeset} ->
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

  defp track_created(conn, %SleepTracker{} = sleep_data) do
    Healthlocker.Analytics.track(conn.assigns.current_user, :create, sleep_data)
  end
end
