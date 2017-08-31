defmodule Healthlocker.Slam.ConnectSlamTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.{User, EPJSTeamMember, ReadOnlyRepo,
                      Slam.ConnectSlam, ClinicianRooms, Room, Carer}

  describe "success paths for connecting as slam su" do
    setup %{} do
      user = %User{
        id: 123456,
        email: "abc123@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
      } |> Repo.insert!

      %EPJSTeamMember{
        Patient_ID: 203,
        Staff_ID: 400,
        Staff_Name: "Andrew Francis",
        Job_Title: "GP",
        Team_Member_Role_Desc: "Care team lead",
        Email: "andrew_francis@nhs.co.uk"
      } |> ReadOnlyRepo.insert!

      multi = ConnectSlam.connect_su_and_create_rooms(user, %{
          first_name: "Lisa",
          last_name: "Sandoval",
          slam_id: 203,
          c4c: true
        }, nil)

      {:ok, result} = Repo.transaction(multi)

      {:ok, result: result}
    end

    test "dry connect slam run" do
      multi = User
              |> Repo.get!(123456)
              |> ConnectSlam.connect_su_and_create_rooms(%{
                  first_name: "Lisa",
                  last_name: "Sandoval",
                  slam_id: 203,
                  c4c: true
                }, nil)

      assert [user: {:update, _, []},
              room: {:insert, _, []},
              carer: {:run, _},
              user_room: {:run, _},
              clinician_room: {:run, _}] = Ecto.Multi.to_list(multi)
    end

    test "user in multi contains a user's updated name and slam id", %{result: result} do
      assert result.user.first_name == "Lisa"
      assert result.user.last_name == "Sandoval"
      assert result.user.c4c
      assert result.user.slam_id == 203
    end

    test "without existing carer", %{result: result} do
      assert result.carer == "No carers to update"
    end

    test "room in multi contains correct room name", %{result: result} do
      assert result.room.name == "service-user-care-team:123456"
    end

    test "user room in multi contains room_id and user_id", %{result: result} do
      assert result.user_room.room_id == result.room.id
      assert result.user_room.user_id == 123456
    end

    test "clinician room in multi inserts_all successfully", %{result: result} do
      assert result.clinician_room == 1
      clinician_room = Repo.get_by(ClinicianRooms, clinician_id: 400)
      assert clinician_room
      assert clinician_room.room_id == result.room.id
    end
  end

  describe "failure for connecting slam" do
    setup %{} do
      user = %User{
        id: 123456,
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password")
      } |> Repo.insert!

      %User{
        id: 123457,
        first_name: "Lisa",
        last_name: "Sandoval",
        email: "abc123@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        slam_id: 203
      } |> Repo.insert!

      multi = ConnectSlam.connect_su_and_create_rooms(user, %{
          first_name: "Lisa",
          last_name: "Sandoval",
          slam_id: 203,
          c4c: false
        }, nil)

      {:ok, multi: multi}
    end

    test "user response with no data" do
      user = Repo.get!(User, 123456)
      multi = ConnectSlam.connect_su_and_create_rooms(user, %{}, nil)
      assert {:error, type, result, _} = Repo.transaction(multi)
      assert result.errors
      assert type == :user
    end

    test "room response on error", %{multi: multi} do
      %Room{
        id: 501,
        name: "service-user-care-team:123456"
      } |> Repo.insert!
      assert {:error, type, result, _} = Repo.transaction(multi)
      assert result.errors
      assert type == :room
    end
  end

  describe "for existing carer" do
    setup %{} do
      user = %User{
        id: 123456,
        email: "abc123@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
      } |> Repo.insert!

      %User{
        id: 123457,
        email: "carer@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        role: "carer"
      } |> Repo.insert!

      carer = %Carer{
        carer_id: 123457,
        caring_id: nil,
        slam_id: 203
      } |> Repo.insert!

      %EPJSTeamMember{
        Patient_ID: 203,
        Staff_ID: 400,
        Staff_Name: "Andrew Francis",
        Job_Title: "GP",
        Team_Member_Role_Desc: "Care team lead",
        Email: "andrew_francis@nhs.co.uk"
      } |> ReadOnlyRepo.insert!

      multi = ConnectSlam.connect_su_and_create_rooms(user, %{
          first_name: "Lisa",
          last_name: "Sandoval",
          slam_id: 203,
          c4c: true
        }, carer)

      {:ok, result} = Repo.transaction(multi)

      {:ok, result: result}
    end

    test "can connect with existing carer & update", %{result: result} do
      assert result.carer == "Carer updated successfully"
      carer = Repo.get_by!(Carer, slam_id: 203)
      assert carer.caring_id == 123456
    end
  end
end
