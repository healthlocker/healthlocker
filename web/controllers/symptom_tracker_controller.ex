defmodule Healthlocker.SymptomTrackerController do
  use Healthlocker.Web, :controller
  alias Healthlocker.{Symptom, SymptomTracker}

  def new(conn, _params) do
    user_id = conn.assigns.current_user.id
    query = from s in Symptom, where: s.user_id == ^user_id

    case Repo.all(query) do
      [symptom | _] ->
        tracker_query = from st in SymptomTracker, where: st.symptom_id == ^symptom.id, order_by: [st.inserted_at]
        [symptom_tracker | _] = Repo.all(tracker_query)
        case Date.compare(NaiveDateTime.to_date(symptom_tracker.inserted_at), Date.utc_today) do
          :eq ->
            conn
            |> put_flash(:error, "You can only track your problem once a day")
            |> redirect(to: toolkit_path(conn, :index))
          _ ->
            changeset = SymptomTracker.changeset(%SymptomTracker{}, %{})
            render conn, "new.html", changeset: changeset, symptom: symptom
        end
      [] ->
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
        |> put_flash(:info, "updated")
        |> redirect(to: toolkit_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end
end
