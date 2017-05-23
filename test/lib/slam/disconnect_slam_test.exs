defmodule Healthlocker.Slam.DisconnectSlamTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.{User, UserRoom, ClinicianRooms, Room, Slam.DisconnectSlam}

  describe "success paths for disconnecting from slam" do
    setup %{} do
      user = %User{
        id: 123456,
        email: "abc123@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
      } |> Repo.insert!

      %Room{
        id: 4321,
        name: "service-user-care-team:123456"
        } |> Repo.insert!

      %UserRoom{
        user_id: 123456,
        room_id: 4321
      } |> Repo.insert!

      %ClinicianRooms{
        clinician_id: 400,
        room_id: 4321
      } |> Repo.insert!

      multi = DisconnectSlam.disconnect_su(user)
      {:ok, result} = Repo.transaction(multi)

      {:ok, result: result}
    end

    test "dry disconnect slam run" do
      multi = User
            |> Repo.get!(123456)
            |> DisconnectSlam.disconnect_su
      assert [user: {:update, _, []},
              user_room: {:run, _},
              clinician_room: {:run, _}] = Ecto.Multi.to_list(multi)
    end

    test "user in multi sets slam_id to nil", %{result: result} do
      assert result.user.slam_id == nil
    end

    test "deletes user_room for user", %{result: result} do
      user_room = Repo.get(UserRoom, result.user_room.id)
      refute user_room
    end

    test "deletes clinician_room for room", %{result: result} do
      clinician_room = Repo.get(ClinicianRooms, result.clinician_room.id)
      refute clinician_room
    end
  end
end
