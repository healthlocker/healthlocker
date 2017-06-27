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
