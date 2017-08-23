defmodule Healthlocker.SymptomTrackerController do
  use Healthlocker.Web, :controller
  alias Healthlocker.{Symptom, SymptomTracker}

  def new(conn, _params) do
    user_id = conn.assigns.current_user.id
    query = from s in Symptom, where: s.user_id == ^user_id

    case Repo.all(query) do
      # checks if a user has a symptom
      [symptom | _] ->
        tracker_query = from st in SymptomTracker, where: st.symptom_id == ^symptom.id, order_by: [desc: st.inserted_at]
        case Repo.all(tracker_query) do
          # if so query SymptomTracker to see if they have tracked that issue yet
          [symptom_tracker | _] ->
            # if the have tracked a symptom check the date for when they last did
            case Date.compare(NaiveDateTime.to_date(symptom_tracker.inserted_at), Date.utc_today) do
              # if date is equal to today's date tell user they can only enter once per day
              :eq ->
                conn
                |> put_flash(:error, "You can only track your problem once a day")
                |> redirect(to: toolkit_path(conn, :index))
              # else let user track symptom
              _ ->
                changeset = SymptomTracker.changeset(%SymptomTracker{}, %{})
                conn
                |> render("new.html", changeset: changeset, symptom: symptom)
            end
          [] ->
            # if a user has a symptom but no tracking let them track symptom
            changeset = SymptomTracker.changeset(%SymptomTracker{}, %{})
            conn
            |> render("new.html", changeset: changeset, symptom: symptom)
        end
      [] ->
      # if a user does not have a symptom redirect to symptom
        conn
        |> redirect(to: symptom_path(conn, :new))
    end
  end

  def create(conn, %{"symptom_tracker" => symptom_tracker}) do
    user_id = conn.assigns.current_user.id
    query = from s in Symptom, where: s.user_id == ^user_id, select: s
    [symptom | _] = Repo.all(query)

    changeset =
      symptom
      |> build_assoc(:symptom_trackers)
      |> SymptomTracker.changeset(symptom_tracker)

    case Repo.insert(changeset) do
      {:ok, _symptom_tracker} ->
        conn
        |> put_flash(:info, "Tracked successfully")
        |> redirect(to: toolkit_path(conn, :index))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset, symptom: symptom)
    end
  end
end
