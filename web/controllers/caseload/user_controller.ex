defmodule Healthlocker.Caseload.UserController do
  use Healthlocker.Web, :controller
  alias Healthlocker.SleepTracker

  alias Healthlocker.{User, ReadOnlyRepo, EPJSUser, EPJSPatientAddressDetails, Goal, Post, Slam.ServiceUser}

  def show(conn, %{"id" => id, "section" => section}) do
    date = Date.to_iso8601(Date.utc_today())
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
      |> SleepTracker.get_sleep_data(service_user.id, Date.utc_today())
      |> Repo.all

    render(conn, String.to_atom(section), user: service_user, slam_user: slam_user,
          address: address, goals: goals, strategies: strategies, room: room,
          sleep_data: sleep_data, date: date)
  end

  def show(conn, %{"id" => id}) do
    show(conn, %{"id" => id, "section" => "details"})
  end
end
