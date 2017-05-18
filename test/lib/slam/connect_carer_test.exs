defmodule Healthlocker.Slam.ConnectCarerTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.{User, Slam.ConnectCarer}

  setup %{} do
    %User{
      id: 123456,
      email: "abc@gmail.com",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password")
    } |> Repo.insert

    %User{
      id: 123457,
      first_name: "Lisa",
      last_name: "Sandoval",
      email: "abc123@gmail.com",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      security_question: "Question?",
      security_answer: "Answer",
      slam_id: 203
    } |> Repo.insert

    :ok
  end

  test "dry carer connection run" do
    user = Repo.get!(User, 123456)
    service_user = Repo.get!(User, 123457)
    multi = ConnectCarer.connect_carer_and_create_rooms(user, %{
      "first_name" => "Kat",
      "last_name" => "Bow"
    }, service_user)
    #
    assert [user: {:update, user_changeset, []},
            carer: {:insert, carer_changeset, []}, room: {:run, function},
            carer_room: {:run, function},
            clinician_room: {:run, function}] = Ecto.Multi.to_list(multi)
    [user, carer, room, carer_room, clinician_room] = Ecto.Multi.to_list(multi)
    IO.inspect room
    IO.inspect carer_room
    assert [user, carer, room, carer_room, clinician_room] = Ecto.Multi.to_list(multi)
  end
end
# [user: {:update, changeset, []},
# carer: {:insert, changeset, []},
# room: {:run, function,
#              carer_room: {:run,
#               #Function<1.84387637/1 in Healthlocker.Slam.ConnectCarer.connect_carer_and_create_rooms/3>},
#              clinician_room: {:run,
#               #Function<2.84387637/1 in Healthlocker.Slam.ConnectCarer.connect_carer_and_create_rooms/3>}]
