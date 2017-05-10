defmodule Healthlocker.CaseloadControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.{EPJSClinician, EPJSPatientAddressDetails,
                      EPJSUser, ReadOnlyRepo, User}

  describe "current_user is assigned in the session" do
    setup do
      %User{
        id: 123456,
        name: "MyName",
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        slam_id: 201
      } |> Repo.insert

      %User{
        id: 123457,
        name: "Robert MacMurray",
        email: "robert_macmurray@nhs.co.uk",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        role: "clinician"
      } |> Repo.insert

      %EPJSClinician{
        GP_Code: "NyNsn50mPQPFZYn7",
        First_Name: "Robert",
        Last_Name: "MacMurray"
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

      {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123457)) }
    end

    test "GET /caseload", %{conn: conn} do
      conn = get conn, caseload_path(conn, :index)
      assert html_response(conn, 200) =~ "Caseload"
    end

    test "GET /caseload/:id/show", %{conn: conn} do
      user = Repo.get!(User, 123456)
      conn = get conn, caseload_path(conn, :show, user)
      assert html_response(conn, 200) =~ "Details and contacts"
    end
  end
end
