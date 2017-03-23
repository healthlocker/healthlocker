defmodule Healthlocker.SleepTrackerControllerTest do
  use Healthlocker.ConnCase, async: false

  alias Healthlocker.SleepTracker
  alias Healthlocker.User
  @valid_attrs %{
    hours_slept: "7",
    wake_count: "4",
    notes: "Some notes",
    user_id: 123456
  }

  describe "with current user" do
    setup do
      %User{
          id: 123456,
          name: "MyName",
          email: "abc@gmail.com",
          password_hash: Comeonin.Bcrypt.hashpwsalt("password")
        } |> Repo.insert

        {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123456)) }
    end

    test "/sleep-tracker :: index", %{conn: conn} do
      conn = get conn, sleep_tracker_path(conn, :index)
      assert html_response(conn, 200) =~ "Sleep Tracker"
    end

    test "/sleep-tracker :: new", %{conn: conn} do
      conn = get conn, sleep_tracker_path(conn, :new)
      assert html_response(conn, 200) =~ "Sleep"
    end

    test "/sleep-tracker :: create", %{conn: conn} do
      conn = post conn, sleep_tracker_path(conn, :create), sleep_tracker: @valid_attrs
      sleep_tracker = Repo.get_by(SleepTracker, notes: "Some notes")
      assert redirected_to(conn) == toolkit_path(conn, :index)
      assert sleep_tracker
    end
  end

  describe "without current user" do
    setup do
      %User{
          id: 123456,
          name: "MyName",
          email: "abc@gmail.com",
          password_hash: Comeonin.Bcrypt.hashpwsalt("password")
        } |> Repo.insert

      :ok
    end

    test "conn is halted for index", %{conn: conn} do
      conn = get conn, sleep_tracker_path(conn, :index)
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "conn is halted for new", %{conn: conn} do
      conn = get conn, sleep_tracker_path(conn, :new)
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "conn is halted for create", %{conn: conn} do
      conn = post conn, sleep_tracker_path(conn, :create)
      assert html_response(conn, 302)
      assert conn.halted
    end
  end
end
