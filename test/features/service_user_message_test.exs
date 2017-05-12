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

    {:ok, %{session: session}}
  end

  test "coming soon", %{session: session} do
    session
    |> log_in("tony@dwyl.io")
    |> click(Query.css("#open-nav"))
    |> click(Query.link("Care team"))

    assert current_path(session) == "/care-team/messages"
    take_screenshot(session)
    assert has_text?(session, "Messaging coming soon.")
  end
end
