defmodule Healthlocker.Caseload.UserControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.{User, ReadOnlyRepo, EPJSUser, EPJSPatientAddressDetails, EPJSTeamMember, Room, UserRoom}

  describe "clinician current_user is assigned" do
    setup do
      %User{
        id: 123_456,
        first_name: "My",
        last_name: "Name",
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        slam_id: 201
      } |> Repo.insert

      %User{
        id: 123_457,
        first_name: "Robert",
        last_name: "MacMurray",
        email: "robert_macmurray@nhs.co.uk",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        user_guid: "yfjhgkhsdf",
        role: "clinician"
      } |> Repo.insert

      %EPJSTeamMember{
        Staff_ID: 12345678,
        Patient_ID: 201,
        Staff_Name: "Robert MacMurray",
        Job_Title: "GP",
        Team_Member_Role_Desc: "Care team lead",
        Email: "robert_macmurray@nhs.co.uk"
      } |> ReadOnlyRepo.insert

      %EPJSUser{
        Patient_ID: 201,
        Surname: "Hernandez",
        Forename: "Angela",
        Title: "Ms.",
        Patient_Name: "Angela Hernandez",
        Trust_ID: "fYXSryfK7N",
        NHS_Number: "LbweJ2oXsNl14ayv37d7",
        DOB: DateTime.from_naive!(~N[1988-05-24 00:00:00.00], "Etc/UTC"),
      } |> ReadOnlyRepo.insert

      %EPJSPatientAddressDetails{
        Patient_ID: 201,
        Address_ID: 1,
        Address1: "123 High Street",
        Address2: "London",
        Address3: "UK",
        Post_Code: "E1 8UW",
        Tel_home: "02085 123 456"
      } |> ReadOnlyRepo.insert

      %Room{
        id: 1,
        name: "service-user-care-team:123456"
      } |> Repo.insert

      %UserRoom{
        user_id: 123456,
        room_id: 1
      } |> Repo.insert

      {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123_457)) }
    end

    test "GET /caseload/users/:id?section=details for details", %{conn: conn} do
      user = Repo.get(User, 123_456)
      conn = get conn, caseload_user_path(conn, :show, user, section: "details")
      assert html_response(conn, 200) =~ "Date of Birth"
    end

    test "GET /caseload/users/:id?section=interactions for interactions", %{conn: conn} do
      user = Repo.get(User, 123_456)
      conn = get conn, caseload_user_path(conn, :show, user, section: "interactions")
      assert html_response(conn, 200) =~ "Coping Strategies"
    end

    test "caseload/users/:id?section=tracking&date=2017-05-18&shift=next", %{conn: conn} do
      user = Repo.get(User, 123_456)
      conn = get conn, caseload_user_path(conn, :show, user, section: "tracking", date: "2017-05-18", shift: "next")
      assert html_response(conn, 200) =~ "Tracking overview"
    end

    test "caseload/users/ works with empty list", %{conn: conn} do
      conn = get conn, caseload_user_path(conn, :index, patients: [])
      assert html_response(conn, 200) =~ "Users not signed up to Healthlocker"
    end

    test "caseload/users/ works with list containing user ids", %{conn: conn} do
      conn = get conn, caseload_user_path(conn, :index, patients: ["180"])
      assert html_response(conn, 200) =~ "Users not signed up to Healthlocker"
    end
  end
end
