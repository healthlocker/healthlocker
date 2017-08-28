defmodule Healthlocker.Caseload.UserController do
  use Healthlocker.Web, :controller
  use Timex
  alias Healthlocker.SleepTracker

  alias Healthlocker.{User, ReadOnlyRepo, EPJSUser, EPJSPatientAddressDetails, Goal, Post, Slam.ServiceUser, EPJSTeamMember}

  def index(conn, %{"patients" => patients_list}) do
    cond do
      conn.assigns.current_user.user_guid ->
        clinician = conn.assigns.current_user
        non_hl = get_non_hl_patients(patients_list)
        conn
        |> render("index.html", non_hl: non_hl)
      true ->
        conn
        |> put_flash(:error, "Authentication failed")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def index(conn, _params) do
    cond do
      conn.assigns.current_user.user_guid ->
        clinician = conn.assigns.current_user
        conn
        |> render("index.html", non_hl: [])
      true ->
        conn
        |> put_flash(:error, "Authentication failed")
        |> redirect(to: page_path(conn, :index))
    end
  end

  defp get_non_hl_patients(patient_ids) do
    patient_ids
    |> Enum.map(fn id ->
      ReadOnlyRepo.all(from e in EPJSUser,
      where: e."Patient_ID" == ^id)
    end)
    |> Enum.concat
    |> Enum.uniq_by(fn user ->
      user."Patient_ID"
    end)
  end

  def show(conn, %{"id" => id, "section" => section, "date" => date, "shift" => shift}) do
    if conn.assigns.current_user.user_guid do
      date = Date.from_iso8601!(date)
      shifted_date = case shift do
        "prev" ->
          Timex.shift(date, days: -7)
        "next" ->
          Timex.shift(date, days: 7)
        end

      details = get_details(id, shifted_date)

      conn
      |> render(String.to_atom(section), user: details.user, slam_user: details.slam_user,
      address: details.address, goals: details.goals, strategies: details.strategies, room: details.room,
      service_user: details.service_user, sleep_data: details.sleep_data, date: details.date,
      symptom_data: details.symptom_data, diary_data: details.diary_data,
      merged_data: details.merged_data)
    else
      conn
      |> put_flash(:error, "Authentication failed")
      |> redirect(to: page_path(conn, :index))
    end
  end

  def show(conn, %{"id" => id, "section" => section}) do
    if conn.assigns.current_user.user_guid do
      details = get_details(id, Date.utc_today())

      conn
      |> render(String.to_atom(section), user: details.user, slam_user: details.slam_user,
      address: details.address, goals: details.goals, strategies: details.strategies,
      room: details.room, service_user: details.service_user, sleep_data: details.sleep_data,
      date: details.date, symptom_data: details.symptom_data, diary_data: details.diary_data,
      merged_data: details.merged_data, care_team: details.care_team)
    else
      conn
      |> put_flash(:error, "Authentication failed")
      |> redirect(to: page_path(conn, :index))
    end
  end

  defp get_details(id, date) do
    user = Repo.get!(User, id)
    room = Repo.one! assoc(user, :rooms)
    service_user = ServiceUser.for(user)
    slam_user = cond do
      Map.has_key?(service_user, "Patient_ID") or Map.has_key?(service_user, :Patient_ID) ->
        service_user
      Map.has_key?(service_user, :id) or Map.has_key?(service_user, "id") ->
        ReadOnlyRepo.one(from e in EPJSUser,
        where: e."Patient_ID" == ^service_user.slam_id)
      true -> nil
    end
    address = ReadOnlyRepo.one(from e in EPJSPatientAddressDetails,
                    where: e."Patient_ID" == ^slam_user."Patient_ID")
    goals = Goal
          |> Goal.get_goals(id)
          |> Repo.all
    strategies = Post
                |> Post.get_coping_strategies(id)
                |> Repo.all

    sleep_data = if Map.has_key?(service_user, :id) do
      SleepTracker
        |> SleepTracker.get_sleep_data(service_user.id, date)
        |> Repo.all
      else
        nil
    end

    date = Date.to_iso8601(date)
    {:ok, date_time, _} = DateTime.from_iso8601(date <> "T23:59:59Z")

    care_team = EPJSTeamMember
                    |> EPJSTeamMember.get_care_team(slam_user."Patient_ID")
                    |> ReadOnlyRepo.all

    symptom_data = if Map.has_key?(service_user, :id) do
      Healthlocker.TrackerController.get_symptom_tracking_data(date_time, service_user.id)
    else
      nil
    end

    diary_data = if Map.has_key?(service_user, :id) do
      Healthlocker.TrackerController.get_diary_data(date_time, service_user.id)
    else
      nil
    end
    merged_data = if !sleep_data and !symptom_data and !diary_data do
      nil
    else
      Healthlocker.TrackerController.merge_tracking_data([], sleep_data, symptom_data, diary_data, DateTime.to_naive(date_time))
    end

    %{user: user, room: room, service_user: service_user, slam_user: slam_user,
    address: address, goals: goals, strategies: strategies, sleep_data: sleep_data,
    date: date, symptom_data: symptom_data, diary_data: diary_data,
    merged_data: merged_data, care_team: care_team}
  end
end
