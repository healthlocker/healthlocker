defmodule Healthlocker.SymptomControllerTest do
  use Healthlocker.ConnCase
  alias Healthlocker.User

  describe "Current user is assigned to the conn" do
    setup do
      %User{
        id: 123456,
        first_name: "My",
        last_name: "Name",
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password")
      } |> Repo.insert

      {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123456)) }
    end

    test "GET /symptom/new", %{conn: conn} do
      conn = get conn, symptom_path(conn, :new)
      assert html_response(conn, 200) =~ "Symptom"
    end
  end
end
