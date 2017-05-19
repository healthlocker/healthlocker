defmodule Healthlocker.Slam.ConnectCarerTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.{User, Slam.ConnectCarer, EPJSTeamMember, ReadOnlyRepo, EPJSClinician, ClinicianRooms}

  describe "test success paths for connecting carer" do
    setup %{} do
      user = %User{
        id: 123456,
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password")
      } |> Repo.insert!

      service_user = %User{
        id: 123457,
        first_name: "Lisa",
        last_name: "Sandoval",
        email: "abc123@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        slam_id: 203
      } |> Repo.insert!

      %EPJSTeamMember{
        Patient_ID: 203,
        Staff_ID: 400
      } |> ReadOnlyRepo.insert!

      %EPJSClinician{
        id: 400,
        First_Name: "Andrew",
        Last_Name: "Francis"
      } |> ReadOnlyRepo.insert!

      multi = ConnectCarer.connect_carer_and_create_rooms(user, %{
        "first_name" => "Kat",
        "last_name" => "Bow"
      }, service_user)

      {:ok, result} = Repo.transaction(multi)

      {:ok, result: result}
    end

    test "dry carer connection run" do
      user = Repo.get!(User, 123456)
      service_user = Repo.get!(User, 123457)
      multi = ConnectCarer.connect_carer_and_create_rooms(user, %{
        "first_name" => "Kat",
        "last_name" => "Bow"
      }, service_user)

      assert [user: {:update, _, []},
              carer: {:insert, _, []},
              room: {:run, _},
              carer_room: {:run, _},
              clinician_room: {:run, _}] = Ecto.Multi.to_list(multi)
    end

    test "user in multi result contains a users with updated name", %{result: result} do
      assert result.user.first_name == "Kat"
      assert result.user.last_name == "Bow"
    end

    test "carer in multi result contains carer_id and caring_id", %{result: result} do
      assert result.carer.carer.id == 123456
      assert result.carer.caring.id == 123457
    end

    test "room in multi result contains room name for carer", %{result: result} do
      assert result.room.name == "carer-care-team:123456"
    end

    test "carer_room in multi result contains room_id and user_id", %{result: result} do
      assert result.carer_room.room_id == result.room.id
      assert result.carer_room.user_id == 123456
    end

    test "clinician_room in multi result inserts_all successfully", %{result: result} do
      # clinician room uses insert_all, so it just returns 1 if successful and 0 if not
      assert result.clinician_room == 1
      clinician_room = Repo.get_by(ClinicianRooms, clinician_id: 400)
      assert clinician_room
      assert clinician_room.room_id == result.room.id
    end
  end

  describe "test failure for connecting carer" do
    setup %{} do
      user = %User{
        id: 123456,
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password")
      } |> Repo.insert!

      service_user = %User{
        id: 123457,
        first_name: "Lisa",
        last_name: "Sandoval",
        email: "abc123@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        slam_id: 203
      } |> Repo.insert!

      multi = ConnectCarer.connect_carer_and_create_rooms(user, %{}, service_user)

      {:ok, multi: multi}

    end

    test "testing", %{multi: multi} do
      assert {:error, type, result, %{}} = Repo.transaction(multi)
      assert result.errors
      assert type == :user
    end
  end
end