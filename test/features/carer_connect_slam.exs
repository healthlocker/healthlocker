defmodule Healthlocker.CarerConnectSlam do
  use Healthlocker.FeatureCase

  setup %{session: session} do
    EctoFactory.insert(:user,
      email: "tony@dwyl.io",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      terms_conditions: true,
      privacy: true,
      data_access: true
    )

    EctoFactory.insert(:user,
      email: "nelson@dwyl.io",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      terms_conditions: true,
      privacy: true,
      data_access: true
    )

    session = session |> log_in
    {:ok, %{session: session}}
  end

  @form                 Query.css("form")
  @first_name_field     Query.text_field("First name")
  @last_name_field      Query.text_field("Last name")
  @date_of_birth_field  Query.text_field("Date of birth")
  @nhs_number_field     Query.text_field("NHS number")
  @connect_button        Query.button("Connect")

  test "successfully connect with SLaM", %{session: session} do
    session
    |> log_in
    |> visit("/account")
    |> take_screenshot
    |> click(Query.link("Connect with the SLaM care team of someone I care for"))
    |> find(@form, fn(form) ->
      form
      |> fill_in(@first_name_field, with: "Tony")
      |> fill_in(@last_name_field, with: "Daly")
      |> click(@connect_button)
    end)

    assert current_path(session) == "/account"
    assert has_text?(session, "Account connected with SLaM")
  end

  test "unsuccessfully connect with SLaM", %{session: session} do
    session
    |> log_in
    |> visit("/account")
    |> take_screenshot
    |> click(Query.link("Connect with the SLaM care team of someone I care for"))
    |> find(@form, fn(form) ->
      form
      |> click(@connect_button)
    end)

    assert has_text?(session, "Your Healthlocker account could not be linked with your SLaM health record. Please check your details are correct and try again.")
  end
end
