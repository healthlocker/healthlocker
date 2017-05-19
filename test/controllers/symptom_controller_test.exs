defmodule Healthlocker.SymptomControllerTest do
  use Healthlocker.ConnCase
  alias Healthlocker.{User, Symptom}

  @valid_attrs %{symptom: "a problem"}
  @invalid_attrs %{symptom: ""}

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
      assert html_response(conn, 200) =~ "Problem tracker"
    end

    test "POST /symptom", %{conn: conn} do
      conn = post conn, symptom_path(conn, :create), symptom: @valid_attrs
      assert redirected_to(conn) == symptom_tracker_path(conn, :new)
    end

    test "does not create symptom and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, symptom_path(conn, :create), symptom: @invalid_attrs
      assert html_response(conn, 200) =~ "Problem tracker"
    end
  end
end
