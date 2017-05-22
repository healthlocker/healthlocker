defmodule Healthlocker.Slam.ConnectSlamTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.{User, Slam.ConnectSlam}

  describe "success paths for connecting as slam su" do
    setup %{} do
      user = %User{
        id: 123456,
        email: "abc123@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
      } |> Repo.insert!

      multi = ConnectSlam.connect_su_and_create_rooms(user, %{
          first_name: "Lisa",
          last_name: "Sandoval",
          slam_id: 203
        })

      {:ok, result} = Repo.transaction(multi)

      {:ok, result: result}
    end

    test "dry connect slam run" do
      multi = User
              |> Repo.get!(123456)
              |> ConnectSlam.connect_su_and_create_rooms(%{
                  first_name: "Lisa",
                  last_name: "Sandoval",
                  slam_id: 203
                })
      assert [user: {:update, _, []},
              room: {:insert, _, []},
              user_room: {:run, _}] = Ecto.Multi.to_list(multi)
    end

    test "user in multi contains a user's updated name and slam id", %{result: result} do
      assert result.user.first_name == "Lisa"
      assert result.user.last_name == "Sandoval"
      assert result.user.slam_id == 203
    end

    test "room in multi contains correct room name", %{result: result} do
      assert result.room.name == "service-user-care-team:123456"
    end

    test "user room in multi contains room_id and user_id", %{result: result} do
      assert result.user_room.room_id == result.room.id
      assert result.user_room.user_id == 123456
    end
  end
end
