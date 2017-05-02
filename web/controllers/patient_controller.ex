defmodule Healthlocker.PatientController do
  use Healthlocker.Web, :controller

  alias Healthlocker.{User, ReadOnlyRepo, EPJSUser, EPJSPatientAddressDetails, Goal, Post}

  def show(conn, %{"caseload_id" => id, "id" => section}) do
    user = Repo.get!(User, id)
    slam_user = ReadOnlyRepo.one(from e in EPJSUser,
                where: e."Patient_ID" == ^user.slam_id)
    address = ReadOnlyRepo.one(from e in EPJSPatientAddressDetails,
                    where: e."Patient_ID" == ^user.slam_id)
    goals = Goal
          |> Goal.get_goals(id)
          |> Repo.all
    strategies = Post
                |> Post.get_coping_strategies(id)
                |> Repo.all
    render(conn, String.to_atom(section), user: user, slam_user: slam_user,
          address: address, goals: goals, strategies: strategies)
  end
end
