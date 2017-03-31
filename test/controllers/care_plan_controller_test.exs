defmodule Healthlocker.CarePlanControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.User

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

    test "/care-plan :: index", %{conn: conn} do
      conn = get conn, care_plan_path(conn, :index)
      assert html_response(conn, 200) =~ "Care plan"
    end
  end

  describe "no current user assigned in session" do
    test "/care-plan :: index", %{conn: conn} do
      conn = get conn, care_plan_path(conn, :index)
      assert html_response(conn, 302)
      assert conn.halted
    end
  end
end
