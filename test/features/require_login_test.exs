defmodule Healthlocker.RequireLoginTest do
  use Healthlocker.FeatureCase

  describe "when user is logged in" do
    setup %{session: session} do
      EctoFactory.insert(:user,
        email: "tony@dwyl.io",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        terms_conditions: true,
        privacy: true,
        data_access: true
      )

      session = session |> log_in
      {:ok, %{session: session}}
    end

    test "shows page", %{session: session} do
      goals_page = session
        |> visit("/goal/new")

      assert current_path(goals_page) == "/goal/new"
    end
  end

  describe "when user is logged out" do
    test "redirects to login page", %{session: session} do
      login_page = session
        |> visit("/goal")

      assert current_path(login_page) == "/login"
      assert has_text?(login_page, "You must be logged in to access that page!")
    end
  end

  @login_form     Query.css("form")
  @email_field    Query.text_field("Email address")
  @password_field Query.text_field("Password")
  @login_button   Query.button("Log in")

  defp log_in(session) do
    page = session |> visit("/login")

    find(page, @login_form, fn(form) ->
      form
      |> fill_in(@email_field, with: "tony@dwyl.io")
      |> fill_in(@password_field, with: "password")
      |> click(@login_button)
    end)
  end
end
