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

  describe "current user assigned & symptom already inserted" do
    setup do
      %User{
        id: 123456,
        first_name: "My",
        last_name: "Name",
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password")
      } |> Repo.insert

      %Symptom{
        user_id: 123456,
        symptom: "anger"
      } |> Repo.insert

      {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123456)) }
    end

    test "/symptom/new redirects to /symptom_tracker/new when symptom exists", %{conn: conn} do
      conn = get conn, symptom_path(conn, :new)
      assert redirected_to(conn) == symptom_tracker_path(conn, :new)
      error_flash = "You can only set up your problem tracker once. Track your problem now."
      assert get_flash(conn, :error) == error_flash
    end

    test "does not create duplicate problem", %{conn: conn} do
      conn = post conn, symptom_path(conn, :create), symptom: @valid_attrs
      assert html_response(conn, 200) =~ "Problem tracker"
      error_flash = "Something went wrong. Try again later."
      assert get_flash(conn, :error) == error_flash
    end
  end
end
