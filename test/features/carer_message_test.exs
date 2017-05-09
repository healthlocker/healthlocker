defmodule Healthlocker.CarerMessageTest do
  use Healthlocker.FeatureCase

  setup %{session: session} do
    carer = EctoFactory.insert(:user,
      email: "tony@dwyl.io",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      terms_conditions: true,
      privacy: true,
      data_access: true
    )

    service_user = EctoFactory.insert(:user,
      email: "bob@dwyl.io",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      terms_conditions: true,
      privacy: true,
      data_access: true
    )

    Repo.insert!(%Healthlocker.Carer{carer: carer, caring: service_user})

    Mix.Tasks.Healthlocker.Room.Create.run("run")

    {:ok, %{session: session}}
  end

  @nav_button Query.css("#open-nav")
  test "view care team messages", %{session: session} do
    session
    |> log_in
    |> click(@nav_button)
    |> click(Query.link("Care team"))

    assert current_path(session) == "/care-team/messages"
  end

  @message_field  Query.css("#message-input")
  @messages_list  Query.css("#message-feed")
  test "send care team message", %{session: session} do
    session
    |> log_in
    |> click(@nav_button)
    |> click(Query.link("Care team"))
    |> fill_in(@message_field, with: "Hello there")
    |> send_keys([:enter])
    |> find(@messages_list, fn(messages) ->
      messages
      |> has_text?("Hello there")
    end)
  end
end
