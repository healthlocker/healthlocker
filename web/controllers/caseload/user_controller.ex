defmodule Healthlocker.Caseload.UserController do
  use Healthlocker.Web, :controller
  use Timex
  alias Healthlocker.SleepTracker

  alias Healthlocker.{User, ReadOnlyRepo, EPJSUser, EPJSPatientAddressDetails, Goal, Post, Slam.ServiceUser}

  def show(conn, %{"id" => id, "section" => section, "date" => date, "shift" => shift}) do
    date = Date.from_iso8601!(date)
    shifted_date = case shift do
      "prev" ->
        Timex.shift(date, days: -7)
      "next" ->
        Timex.shift(date, days: 7)
    end

    details = get_details(id, shifted_date)

    render(conn, String.to_atom(section), user: details.user, slam_user: details.slam_user,
          address: details.address, goals: details.goals, strategies: details.strategies, room: details.room,
          service_user: details.service_user, sleep_data: details.sleep_data, date: details.date,
          symptom_data: details.symptom_data, merged_data: details.merged_data)
  end

  def show(conn, %{"id" => id, "section" => section}) do
    details = get_details(id, Date.utc_today())

    render(conn, String.to_atom(section), user: details.user, slam_user: details.slam_user,
          address: details.address, goals: details.goals, strategies: details.strategies,
          room: details.room, service_user: details.service_user, sleep_data: details.sleep_data,
          date: details.date, symptom_data: details.symptom_data, merged_data: details.merged_data)
  end

  defp get_details(id, date) do
    user = Repo.get!(User, id)
    room = Repo.one! assoc(user, :rooms)
    service_user = ServiceUser.for(user)
    slam_user = ReadOnlyRepo.one(from e in EPJSUser,
                where: e."Patient_ID" == ^service_user.slam_id)
    address = ReadOnlyRepo.one(from e in EPJSPatientAddressDetails,
                    where: e."Patient_ID" == ^service_user.slam_id)
    goals = Goal
          |> Goal.get_goals(id)
          |> Repo.all
    strategies = Post
                |> Post.get_coping_strategies(id)
                |> Repo.all

    sleep_data = SleepTracker
      |> SleepTracker.get_sleep_data(service_user.id, date)
      |> Repo.all

    date = Date.to_iso8601(date)
    {:ok, date_time, _} = DateTime.from_iso8601(date <> "T23:59:59Z")

    symptom_data = Healthlocker.TrackerController.get_symptom_tracking_data(date_time, service_user.id)
    merged_data = Healthlocker.TrackerController.merge_tracking_data([], sleep_data, symptom_data, NaiveDateTime.utc_now())

    %{user: user, room: room, service_user: service_user, slam_user: slam_user,
    address: address, goals: goals, strategies: strategies, sleep_data: sleep_data,
    date: date, symptom_data: symptom_data, merged_data: merged_data}
  end
end
