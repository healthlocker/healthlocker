defmodule Healthlocker.CareTeamTest do
  use Healthlocker.FeatureCase
  alias Healthlocker.Carer

  setup %{session: session} do
    carer = EctoFactory.insert(:user,
      email: "tony@dwyl.io",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      terms_conditions: true,
      privacy: true,
      data_access: true,
      slam_id: nil
    )

    bob = EctoFactory.insert(:user,
      email: "bob@dwyl.io",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      terms_conditions: true,
      privacy: true,
      data_access: true
    )

    relationship = %Carer{caring: bob, carer: carer}
    Repo.insert(relationship)

    Mix.Tasks.Healthlocker.Room.Create.run("run")

    session = session |> log_in
    {:ok, %{session: session}}
  end

  @nav_button Query.css("#open-nav")
  @care_team_link Query.link("Care team")
  @message_input Query.css("#message-input")
  @contacts_link Query.link("Contacts")

  describe "when the user is connected as a carer" do
    test "can see Care team menu", %{session: session} do
      session |> click(@nav_button) |> find(@care_team_link)
    end

    test "can send messages", %{session: session} do
      session
      |> click(@nav_button)
      |> click(@care_team_link)
      |> fill_in(@message_input, with: "Hello")
      |> send_keys([:enter])
      |> has_text?("Hello")
    end

    test "can click on contacts", %{session: session} do
      session
      |> click(@nav_button)
      |> click(@care_team_link)
      |> click(@contacts_link)

      assert has_text?(session, "'s care team")
    end
  end
end
