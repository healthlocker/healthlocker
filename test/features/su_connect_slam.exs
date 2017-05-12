defmodule Healthlocker.SUConnectSlam do
  use Healthlocker.FeatureCase

  setup %{session: session} do
    EctoFactory.insert(:user,
      email: "tony@dwyl.io",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      terms_conditions: true,
      privacy: true,
      data_access: true
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

  @form                 Query.css("form")
  @first_name_field     Query.text_field("user_Forename")
  @last_name_field      Query.text_field("user_Surname")
  @date_of_birth_field  Query.text_field("user_DOB")
  @nhs_number_field     Query.text_field("user_NHS_Number")
  @connect_button       Query.button("Connect")

  test "successfully connect with SLaM", %{session: session} do
    session
    |> log_in
    |> visit("/account/slam")
    |> take_screenshot
    |> find(@form, fn(form) ->
      form
      |> fill_in(@first_name_field, with: "Kat")
      |> fill_in(@last_name_field, with: "Bow")
      |> fill_in(@date_of_birth_field, with: "01/01/1989")
      |> fill_in(@nhs_number_field, with: "9434765919")
      |> click(@connect_button)
    end)

    assert has_text?(session, "SLaM account connected!")
    assert has_text?(session, "Account connected with SLaM")
  end

  test "unsuccessfully connect with SLaM", %{session: session} do
    session
    |> log_in
    |> visit("/account/slam")
    |> take_screenshot
    |> find(@form, fn(form) ->
      form
      |> click(@connect_button)
    end)

    assert has_text?(session, "Details do not match. Please try again later")
  end
end
