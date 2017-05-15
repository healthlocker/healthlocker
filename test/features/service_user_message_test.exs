defmodule Healthlocker.ServiceUserMessageTest do
  use Healthlocker.FeatureCase

  setup %{session: session} do
    EctoFactory.insert(:user,
      email: "tony@dwyl.io",
      first_name: "Tony",
      last_name: "Daly",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      terms_conditions: true,
      privacy: true,
      data_access: true,
      slam_id: 202
    )
    Mix.Tasks.Healthlocker.Room.Create.run("run")

    {:ok, %{session: session}}
  end

  test "view messages", %{session: session} do
    session
    |> log_in("tony@dwyl.io")
    |> click(Query.css("#open-nav"))
    |> click(Query.link("Care team"))

    assert current_path(session) =~ "/care-team/rooms/"
    assert has_text?(session, "Messages")
  end
end
