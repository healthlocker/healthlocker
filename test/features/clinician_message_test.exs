defmodule Healthlocker.ClinicianMessageTest do
  use Healthlocker.FeatureCase
  alias Healthlocker.{Carer, EPJSPatientAddressDetails, EPJSClinician, EPJSTeamMember, ReadOnlyRepo, Repo, User}

  setup %{session: session} do
    service_user = EctoFactory.insert(:user,
      email: "tony@dwyl.io",
      first_name: "Tony",
      last_name: "Daly",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      terms_conditions: true,
      privacy: true,
      data_access: true,
      slam_id: 202
    )

    carer = EctoFactory.insert(:user,
      email: "bob@dwyl.io",
      first_name: "General",
      last_name: "Kenobi",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      terms_conditions: true,
      privacy: true,
      data_access: true
    )

    Repo.insert!(%Carer{carer: carer, caring: service_user})

    Repo.insert!(%User{
      email: "clinician@nhs.co.uk",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      first_name: "Mary",
      last_name: "Clinician",
      phone_number: "07598 765 432",
      security_question: "Name of first boss?",
      security_answer: "Betty",
      data_access: true,
      role: "clinician"
    })
    session |> log_in("clinician@nhs.co.uk")

    clinician = ReadOnlyRepo.insert!(%EPJSClinician{
      GP_Code: "yr68Dobil7yD40Ag",
      First_Name: "Mary",
      Last_Name: "Clinician"
    })

    ReadOnlyRepo.insert!(%Healthlocker.EPJSUser{id: 789,
      Patient_ID: 202,
      Surname: "Bow",
      Forename: "Kat",
      NHS_Number: "9434765919",
      DOB: DateTime.from_naive!(~N[1989-01-01 00:00:00.00], "Etc/UTC"),
    })

    ReadOnlyRepo.insert!(%EPJSPatientAddressDetails{
      Patient_ID: 202,
      Address_ID: 1,
      Address1: "123 High Street",
      Address2: "London",
      Address3: "UK",
      Post_Code: "E1 8UW",
      Tel_home: "02085 123 456"
    })

    ReadOnlyRepo.insert!(%EPJSTeamMember{
      Patient_ID: 202,
      Staff_ID: clinician.id
    })

    Mix.Tasks.Healthlocker.Room.Create.run("run")

    {:ok, %{session: session}}
  end

  test "view list of carers", %{session: session} do
    session
    |> resize_window(768, 1024) # The caseload link doesn't show on mobile.
    |> click(Query.link("Caseload"))

    assert has_text?(session, "General Kenobi (carer)")
  end

  test "message carer", %{session: session} do
    session
    |> resize_window(768, 1024) # The caseload link doesn't show on mobile.
    |> click(Query.link("Caseload"))
    |> click(Query.link("General Kenobi (carer)"))
    |> fill_in(Query.css("#message-input"), with: "Hello there")
    |> send_keys([:enter])
    |> has_text?("Hello there")
  end

  test "message service user", %{session: session} do
    session
    |> resize_window(768, 1024) # The caseload link doesn't show on mobile.
    |> click(Query.link("Caseload"))
    |> click(Query.link("Tony Daly"))
    |> click(Query.link("Messages"))
    |> fill_in(Query.css("#message-input"), with: "Sand")
    |> send_keys([:enter])
    |> has_text?("Sand")
  end
end
