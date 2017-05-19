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

  @nav Query.css("#open-nav")
  @care_team_link Query.link("Care team")
  @message_input Query.css("#message-input")
  @contacts_link Query.link("Contacts")

  test "view messages", %{session: session} do
    session
    |> log_in("tony@dwyl.io")
    |> click(@nav)
    |> click(@care_team_link)

    assert current_path(session) =~ "/care-team/rooms/"
    assert has_text?(session, "Messages")
  end

  test "send messages", %{session: session} do
    session
    |> log_in("tony@dwyl.io")
    |> click(@nav)
    |> click(@care_team_link)
    |> fill_in(@message_input, with: "Hi there")
    |> send_keys([:enter])
    |> has_text?("Hi there")
  end

  test "can click on contacts", %{session: session} do
    session
    |> log_in("tony@dwyl.io")
    |> click(@nav)
    |> click(@care_team_link)
    |> click(@contacts_link)

    assert has_text?(session, "Your care team")
    assert has_text?(session, "SLaM care team")
  end
end
