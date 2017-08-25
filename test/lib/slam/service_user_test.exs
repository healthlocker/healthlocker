defmodule Healthlocker.Slam.ServiceUserTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.{Slam.ServiceUser, User, Carer, EPJSUser, ReadOnlyRepo}

  describe "returns correct su for each user type" do
    setup %{} do
      user = %User{
        id: 1234,
        email: "service_user@mail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        slam_id: 1
      } |> Repo.insert!

      carer1 = %User{
        id: 1235,
        email: "carer1@mail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        role: "carer"
      } |> Repo.insert!

      carer2 = %User{
        id: 1236,
        email: "carer2@mail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        role: "carer"
      } |> Repo.insert!

      %Carer{
        carer_id: 1235,
        caring_id: 1234,
        slam_id: 1
      } |> Repo.insert!

      %Carer{
        carer_id: 1236,
        caring_id: nil,
        slam_id: 2
      } |> Repo.insert!

      slam_su = %EPJSUser{
        Patient_ID: 2,
        Forename: "Kat",
        Surname: "Bow"
      } |> ReadOnlyRepo.insert!

      {:ok, user: user, carer1: carer1, carer2: carer2, slam_su: slam_su}
    end

    test "for returns the service user if they have a slam_id", %{user: user} do
      actual = ServiceUser.for(user)
      assert actual == user
    end

    test "for returns the service user from carers table if they are in HL", %{carer1: carer1, user: user} do
      actual = ServiceUser.for(carer1)
      assert actual == user
    end

    test "for returns the service user from epjs if they are not in HL", %{carer2: carer2, slam_su: slam_su} do
      actual = ServiceUser.for(carer2)
      assert actual == slam_su
    end
  end
end
