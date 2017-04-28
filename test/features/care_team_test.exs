defmodule Healthlocker.CareTeamTest do
  use Healthlocker.FeatureCase
  alias Healthlocker.Carer

  setup %{session: session} do
    carer = EctoFactory.insert(:user,
      email: "tony@dwyl.io",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      terms_conditions: true,
      privacy: true,
      data_access: true
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

    session = session |> log_in
    {:ok, %{session: session}}
  end

  @nav_button Query.css("#open-nav")

  # describe "when the user isn't connected to SLaM" do
  #   test "can't see Care Team menu", %{session: session} do
  #     assert_raise Wallaby.QueryError, fn ->
  #       session |> click(@nav_button) |> find(Query.link("Care team"))
  #     end
  #   end
  # end

  describe "when the user is connected to SLaM" do
    test "can see Care team menu", %{session: session} do
      session |> click(@nav_button) |> find(Query.link("Care team"))
    end
  end
end
