defmodule Healthlocker.CaseloadControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.{EPJSTeamMember, ReadOnlyRepo, User}

  describe "current_user is assigned in the session with epjs User_Guid" do
    setup do
      %User{
        id: 123457,
        first_name: "Robert",
        last_name: "MacMurray",
        email: "robert_macmurray@nhs.co.uk",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        role: "clinician",
        user_guid: "someotherrandomstring"
      } |> Repo.insert

      %EPJSTeamMember{
        Staff_ID: 12345678,
        Patient_ID: 201,
        Staff_Name: "Robert MacMurray",
        Job_Title: "GP",
        Team_Member_Role_Desc: "Care team lead",
        Email: "robert_macmurray@nhs.co.uk",
        User_Guid: "someotherrandomstring"
      } |> ReadOnlyRepo.insert

      %EPJSTeamMember{
        Staff_ID: 326746,
        Patient_ID: 20,
        Staff_Name: "Other Person",
        Job_Title: "GP",
        Team_Member_Role_Desc: "Care team lead",
        Email: "other_email@nhs.co.uk",
        User_Guid: "randomstringtotestwith"
      } |> ReadOnlyRepo.insert

      {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123457)) }
    end

    test "GET /caseload", %{conn: conn} do
      conn = get conn, caseload_path(conn, :index)
      assert html_response(conn, 200) =~ "Caseload"
    end

    test "GET /caseload?=userData without HL user", %{conn: conn} do
      # refute before and assert after to ensure HL user has been created
      refute Repo.get_by(User, email: "other_email@nhs.co.uk")
      conn = get conn, "/caseload?userData=UserName=other_email@nhs.co.uk&UserId=randomstringtotestwith&tokenexpiry=2017-06-23T11:15:53"
      assert html_response(conn, 200) =~ "Caseload"
      assert Repo.get_by(User, email: "other_email@nhs.co.uk")
    end

    test "GET /caseload?=userData with HL user", %{conn: conn} do
      %User{
        first_name: "Other",
        last_name: "Person",
        email: "other_email@nhs.co.uk",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        user_guid: "randomstringtotestwith"
      } |> Repo.insert
      conn = get conn, "/caseload?userData=UserName=other_email@nhs.co.uk&UserId=randomstringtotestwith&tokenexpiry=2017-06-23T11:15:53"
      assert html_response(conn, 200) =~ "Caseload"
    end
  end

  describe "no current user assigned" do
    # repeat tests with userData to ensure clinician is logged in
    setup do
      %EPJSTeamMember{
        Staff_ID: 326746,
        Patient_ID: 20,
        Staff_Name: "Other Person",
        Job_Title: "GP",
        Team_Member_Role_Desc: "Care team lead",
        Email: "other_email@nhs.co.uk",
        User_Guid: "randomstringtotestwith"
      } |> ReadOnlyRepo.insert

      :ok
    end

    # check that index without userdata cannot be accessed without being logged in
    test "GET /caseload", %{conn: conn} do
      conn = get conn, caseload_path(conn, :index)
      assert redirected_to(conn) == login_path(conn, :index)
    end

    test "GET /caseload?=userData without HL user", %{conn: conn} do
      # refute before and assert after to ensure HL user has been created
      refute Repo.get_by(User, email: "other_email@nhs.co.uk")
      conn = get conn, "/caseload?userData=UserName=other_email@nhs.co.uk&UserId=randomstringtotestwith&tokenexpiry=2017-06-23T11:15:53"
      assert html_response(conn, 200) =~ "Caseload"
      assert Repo.get_by(User, email: "other_email@nhs.co.uk")
    end

    test "GET /caseload?=userData with HL user", %{conn: conn} do
      %User{
        first_name: "Other",
        last_name: "Person",
        email: "other_email@nhs.co.uk",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        user_guid: "randomstringtotestwith"
      } |> Repo.insert
      conn = get conn, "/caseload?userData=UserName=other_email@nhs.co.uk&UserId=randomstringtotestwith&tokenexpiry=2017-06-23T11:15:53"
      assert html_response(conn, 200) =~ "Caseload"
    end
  end
      %User{
        id: 123457,
        first_name: "Robert",
        last_name: "MacMurray",
        email: "robert_macmurray@nhs.co.uk",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
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

      %Room{
        id: 1,
        name: "service-user-care-team:123456"
      } |> Repo.insert

      %UserRoom{
        user_id: 123456,
        room_id: 1
      } |> Repo.insert

      {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123457)) }
    end

    test "GET /caseload", %{conn: conn} do
      conn = get conn, caseload_path(conn, :index)
      assert html_response(conn, 200) =~ "Caseload"
    end
  end
end
