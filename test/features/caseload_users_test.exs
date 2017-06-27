defmodule Healthlocker.CaseloadUsersTest do
  use Healthlocker.FeatureCase
  alias Healthlocker.{Carer, EPJSPatientAddressDetails, EPJSTeamMember, ReadOnlyRepo, Repo, User}

  setup %{session: session} do
    service_user_1 = EctoFactory.insert(:user,
      email: "tony@dwyl.io",
      first_name: "Tony",
      last_name: "Daly",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      terms_conditions: true,
      privacy: true,
      data_access: true,
      slam_id: 202
    )

    ReadOnlyRepo.insert!(%Healthlocker.EPJSUser{
      Patient_ID: 202,
      Surname: "Tony",
      Forename: "Daly",
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

    service_user_2 = EctoFactory.insert(:user,
      email: "kat@dwyl.io",
      first_name: "Kat",
      last_name: "Bow",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      terms_conditions: true,
      privacy: true,
      data_access: true,
      slam_id: 203
    )

    carer = EctoFactory.insert(:user,
      email: "carer@dwyl.io",
      first_name: "Jimmy",
      last_name: "Smits",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      terms_conditions: true,
      privacy: true,
      data_access: true,
      slam_id: nil
    )

    Repo.insert!(%Carer{carer: carer, caring: service_user_1})

    Repo.insert!(%User{
      email: "robert_macmurray@nhs.co.uk",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      first_name: "Mary",
      last_name: "Clinician",
      phone_number: "07598 765 432",
      security_question: "Name of first boss?",
      security_answer: "Betty",
      data_access: true,
      role: "clinician",
      user_guid: "randomstring"
    })

    %EPJSTeamMember{
      Staff_ID: 12345678,
      Patient_ID: 202,
      Staff_Name: "Robert MacMurray",
      Job_Title: "GP",
      Team_Member_Role_Desc: "Care team lead",
      Email: "robert_macmurray@nhs.co.uk"
    } |> ReadOnlyRepo.insert

    %EPJSTeamMember{
      Staff_ID: 12345678,
      Patient_ID: 203,
      Staff_Name: "Robert MacMurray",
      Job_Title: "GP",
      Team_Member_Role_Desc: "Care team lead",
      Email: "robert_macmurray@nhs.co.uk"
    } |> ReadOnlyRepo.insert

    Mix.Tasks.Healthlocker.Room.Create.run("run")

    {:ok, %{session: session}}
  end

  test "shows service users", %{session: session} do
    session
    |> resize_window(768, 1024)
    |> log_in("robert_macmurray@nhs.co.uk")
    |> click(Query.link("Caseload"))

    assert session |> has_text?("Tony Daly")
    assert session |> has_text?("Kat Bow")
  end

  test "shows carers", %{session: session} do
    session
    |> resize_window(768, 1024)
    |> log_in("robert_macmurray@nhs.co.uk")
    |> click(Query.link("Caseload"))
    |> take_screenshot

    assert session |> has_text?("Jimmy Smits (friend/family/carer)")
  end

  test "view service user", %{session: session} do
    session
    |> resize_window(768, 1024)
    |> log_in("robert_macmurray@nhs.co.uk")
    |> click(Query.link("Caseload"))
    |> click(Query.link("Tony Daly"))
    |> click(Query.link("Details and contacts"))
    |> take_screenshot

    assert session |> has_text?("123 High Street")
    assert session |> has_text?("tony@dwyl.io")
  end

  test "service user send message", %{session: session} do
    session
    |> resize_window(768, 1024)
    |> log_in("robert_macmurray@nhs.co.uk")
    |> click(Query.link("Caseload"))
    |> click(Query.link("Tony Daly"))
    |> click(Query.link("Messages"))
  end

  test "view carer", %{session: session} do
    session
    |> resize_window(768, 1024)
    |> log_in("robert_macmurray@nhs.co.uk")
    |> click(Query.link("Caseload"))
    |> click(Query.link("Jimmy Smits (friend/family/carer)"))
    |> click(Query.link("Details and contacts"))

    assert session |> has_text?("Jimmy Smits")
  end

  test "view tracking overview", %{session: session} do
    session
    |> resize_window(768, 1024)
    |> log_in("robert_macmurray@nhs.co.uk")
    |> click(Query.link("Caseload"))
    |> click(Query.link("Tony Daly"))
    |> click(Query.link("Tracking"))

    assert has_text?(session, "Tracking overview")
  end
end
