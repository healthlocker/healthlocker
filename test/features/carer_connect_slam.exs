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
      data_access: true,
      slam_id: 200
    )

    Healthlocker.ReadOnlyRepo.insert!(%Healthlocker.EPJSUser{id: 789,
      Patient_ID: 200,
      Surname: "Bow",
      Forename: "Kat",
      NHS_Number: "9434765919",
      DOB: DateTime.from_naive!(~N[1989-01-01 00:00:00.00], "Etc/UTC"),
    })

    session = session |> log_in
    {:ok, %{session: session}}
  end

  @connect_link         Query.link("Connect with the SLaM care team of someone I care for")
  @form                 Query.css("form")
  @first_name_field     Query.text_field("carer_connection_first_name")
  @last_name_field      Query.text_field("carer_connection_last_name")
  @forename_field       Query.text_field("carer_connection_forename")
  @surname_field        Query.text_field("carer_connection_surname")
  @date_of_birth_field  Query.text_field("Date of birth")
  @nhs_number_field     Query.text_field("NHS number")
  @connect_button       Query.button("Connect")

  test "successfully connect with SLaM", %{session: session} do
    session
    |> log_in
    |> visit("/account")
    |> take_screenshot
    |> click(@connect_link)
    |> find(@form, fn(form) ->
      form
      |> fill_in(@first_name_field, with: "Tony")
      |> fill_in(@last_name_field, with: "Daly")
      |> fill_in(@forename_field, with: "Kat")
      |> fill_in(@surname_field, with: "Bow")
      |> fill_in(@date_of_birth_field, with: "01/01/1989")
      |> fill_in(@nhs_number_field, with: "943 476 5919")
      |> click(@connect_button)
    end)

    assert current_path(session) == "/account"
    assert has_text?(session, "Account connected with SLaM")
  end

  test "unsuccessfully update name", %{session: session} do
    session
    |> log_in
    |> visit("/account")
    |> take_screenshot
    |> click(@connect_link)
    |> find(@form, fn(form) ->
      form
      |> fill_in(@forename_field, with: "Kat")
      |> fill_in(@surname_field, with: "Bow")
      |> fill_in(@date_of_birth_field, with: "01/01/1989")
      |> fill_in(@nhs_number_field, with: "943 476 5919")
      |> click(@connect_button)
    end)

    assert has_text?(session, "Something went wrong")
  end

  test "unsuccessfully connect with SLaM", %{session: session} do
    session
    |> log_in
    |> visit("/account")
    |> take_screenshot
    |> click(@connect_link)
    |> find(@form, fn(form) ->
      form
      |> click(@connect_button)
    end)

    assert has_text?(session, "Your Healthlocker account could not be linked with your SLaM health record. Please check your details are correct and try again.")
  end
end
