defmodule Healthlocker.SleepTrackerController do
  use Healthlocker.Web, :controller
  use Timex
  alias Healthlocker.SleepTracker
  import Healthlocker.ComponentHelpers.Link

  def new(conn, _params) do
    user = conn.assigns.current_user
    sleep_data = SleepTracker
                |> SleepTracker.get_sleep_data_today(user.id)
                |> Repo.one

    case sleep_data do
      nil ->
        changeset = SleepTracker.changeset(%SleepTracker{})
        conn
        |> render("new.html", changeset: changeset)
      _ ->
        conn
        |> put_flash(:error, "You can only enter sleep once per day.")
        |> redirect(to: toolkit_path(conn, :index))
    end
  end

  def create(conn, %{"sleep_tracker" => st_params}) do
    user = conn.assigns.current_user
    changeset = SleepTracker.changeset(%SleepTracker{}, st_params)
              |> Ecto.Changeset.put_assoc(:user, user)
              |> Ecto.Changeset.put_change(:for_date, Timex.shift(Date.utc_today(), days: -1))

    case Repo.insert(changeset) do
      {:ok, params} ->
        conn |> track_created(params)
        conn
        |> put_flash(:info, ["Tracker saved successfully, view it in ",
        link_to("Tracking Overview", to: tracker_path(conn, :index))])
        |> redirect(to: toolkit_path(conn, :index))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end

  defp track_created(conn, %SleepTracker{} = sleep_data) do
    Healthlocker.Analytics.track(conn.assigns.current_user, :create, sleep_data)
  end
end
