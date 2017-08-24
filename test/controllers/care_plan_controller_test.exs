defmodule Healthlocker.CarePlanControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.{User, EPJSSummaryNeeds, EPJSRecoveryCarePlan,
  EPJSRcpLifeEventTriggers, EPJSRcpHelpFromOthers, EPJSRcpGoalsAsp,
  EPJSRCPDailyActivity, EPJSRcpContingency}

  describe "current_user is assigned in the session" do
    setup do
      %User{
        id: 123456,
        first_name: "My",
        last_name: "Name",
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        slam_id: 203
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
