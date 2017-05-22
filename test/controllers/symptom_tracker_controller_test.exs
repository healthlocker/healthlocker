defmodule Healthlocker.SymptomTrackerControllerTest do
  use Healthlocker.ConnCase
  use Timex
  alias Healthlocker.{User, Symptom, SymptomTracker}

  @valid_attrs %{affected_scale: "1"}
  @invalid_attrs %{affected_scale: ""}

  describe "Current user is assigned to the conn but with NO symptom created" do
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

    test "GET /symptom-tracker/new", %{conn: conn} do
      conn = get conn, symptom_tracker_path(conn, :new)
      assert html_response(conn, 302) =~ "/symptom/new"
    end
  end

  describe "Current user is assigned to the conn with a symptom created" do
    setup do
      %User{
        id: 123456,
        first_name: "My",
        last_name: "Name",
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password")
      } |> Repo.insert

      {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123456)), symptom: Repo.insert! %Symptom{symptom: "my problem", user_id: 123456} }
    end

    test "GET /symptom-tracker/new", %{conn: conn} do
      conn = get conn, symptom_tracker_path(conn, :new)
      assert html_response(conn, 200) =~ "Problem tracker:"
    end

    test "POST /symptom-tracker", %{conn: conn} do
      conn = post conn, symptom_tracker_path(conn, :create), symptom_tracker: @valid_attrs
      assert redirected_to(conn) == toolkit_path(conn, :index)
    end

    test "does not create symptom_tracker and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, symptom_tracker_path(conn, :create), symptom_tracker: @invalid_attrs
      assert html_response(conn, 200) =~ "Problem tracker:"
    end
  end

  describe "User is assigned, has made a symptom and tracked that symptom" do
    setup do
      %User{
        id: 123456,
        first_name: "My",
        last_name: "Name",
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password")
      } |> Repo.insert
      %Symptom{
        id: 501,
        symptom: "my problem",
        user_id: 123456
      } |> Repo.insert
      %SymptomTracker{
        affected_scale: "1",
        notes: "not too bad",
        symptom_id: 501,
        inserted_at: Timex.shift(DateTime.utc_now(), days: -1),
        updated_at: Timex.shift(DateTime.utc_now(), days: -1),
      } |> Repo.insert

      {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123456))}
    end
    test "if user as already made a symptom tracker that day they get redirected to toolkit", %{conn: conn} do
      %SymptomTracker{
        affected_scale: "1",
        notes: "not too bad",
        symptom_id: 501
      } |> Repo.insert
      conn = get conn, symptom_tracker_path(conn, :new)
      assert redirected_to(conn) == toolkit_path(conn, :index)
    end

    test "if user as already made a symptom tracker but not for today", %{conn: conn} do
      conn = get conn, symptom_tracker_path(conn, :new)
      assert html_response(conn, 200) =~ "Goals and tracking"
    end
  end
end
