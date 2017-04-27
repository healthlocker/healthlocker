defmodule Healthlocker.CaseloadControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.{EPJSClinician, ReadOnlyRepo, User}

  describe "current_user is assigned in the session" do
    setup do
      %User{
        id: 123456,
        name: "MyName",
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer"
      } |> Repo.insert

      %EPJSClinician{
        GP_Code: "NyNsn50mPQPFZYn7",
        First_Name: "Robert",
        Last_Name: "MacMurray"
      } |> ReadOnlyRepo.insert

      {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123456)) }
    end

    test "GET /caseload", %{conn: conn} do
      conn = get conn, caseload_path(conn, :index)
      assert html_response(conn, 200) =~ "Caseload"
    end

    test "GET /caseload/:id/show", %{conn: conn} do
      conn = get conn, caseload_path(conn, :show, conn.assigns.current_user)
      assert html_response(conn, 200) =~ "Details and contacts"
    end
  end
end
