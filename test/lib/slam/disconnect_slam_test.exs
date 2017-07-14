defmodule Healthlocker.Slam.DisconnectSlamTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.{User, UserRoom, ClinicianRooms, Room, Slam.DisconnectSlam,
                      Message}

  describe "success paths for disconnecting from slam" do
    setup %{} do
      user = %User{
        id: 123456,
        email: "abc123@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        slam_id: 200
      } |> Repo.insert!

      %User{
        id: 654321,
        email: "123abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        slam_id: 201
      } |> Repo.insert!

      %Room{
        id: 4321,
        name: "service-user-care-team:123456"
        } |> Repo.insert!

      %Room{
        id: 4322,
        name: "service-user-care-team:654321"
        } |> Repo.insert!

      %UserRoom{
        user_id: 123456,
        room_id: 4321
      } |> Repo.insert!

      %UserRoom{
        id: 900,
        user_id: 654321,
        room_id: 4322
      } |> Repo.insert!

      %ClinicianRooms{
        clinician_id: 400,
        room_id: 4321
      } |> Repo.insert!

      %ClinicianRooms{
        id: 900,
        clinician_id: 400,
        room_id: 4322
      } |> Repo.insert!

      %Message{
        body: "Hello",
        name: "Katherine",
        user_id: 123456,
        room_id: 4321
      } |> Repo.insert!

      %Message{
        id: 900,
        body: "Hi",
        name: "Rob",
        user_id: 654321,
        room_id: 4322
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
              clinician_room: {:run, _},
              messages: {:run, _},
              room: {:run, _}] = Ecto.Multi.to_list(multi)
    end

    test "user in multi sets slam_id to nil", %{result: result} do
      other_user = Repo.get!(User, 654321)
      assert result.user.slam_id == nil
      assert other_user
    end

    test "deletes user_room for user", %{result: result} do
      other_user_room = Repo.get!(UserRoom, 900)
      user_room = Repo.get(UserRoom, result.user_room.id)
      refute user_room
      assert other_user_room
    end

    test "deletes clinician_room for room", %{result: result} do
      other_clinician_room = Repo.get!(ClinicianRooms, 900)
      clinician_room = Repo.get(ClinicianRooms, result.clinician_room)
      refute clinician_room
      assert other_clinician_room
    end

    test "deletes messages for room", %{result: result} do
      other_messages = Repo.all(from m in Message, where: m.id == 900)
      messages = Repo.all(from m in Message, where: m.room_id == ^result.user_room.room_id)
      assert Kernel.length(messages) == 0
      assert Kernel.length(other_messages) > 0
    end

    test "delete room for service user", %{result: result} do
      other_rooms = Repo.get(Room, 4322)
      room = Repo.get(Room, result.user_room.room_id)
      refute room
      assert other_rooms
    end
  end
end
