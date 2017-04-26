defmodule Healthlocker.CaseloadControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.{EPJSTeamMember, EPJSUser, ReadOnlyRepo, User}

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

      {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123456)) }
    end

    test "/caseload :: index", %{conn: conn} do
      conn = get conn, caseload_path(conn, :index)
      assert html_response(conn, 200) =~ "Caseload"
    end
  end
end
