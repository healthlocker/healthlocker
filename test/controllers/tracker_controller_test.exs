defmodule Healthlocker.TrackerControllerTest do
  use Healthlocker.ConnCase
  alias Healthlocker.User

  describe "with current user" do
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

    test "/tracking-overview :: index", %{conn: conn} do
      conn = get conn, tracker_path(conn, :index)
      assert html_response(conn, 200) =~ "Tracking overview"
    end

    test "/sleep-tracker :: prev-date", %{conn: conn} do
      date = Date.to_iso8601(Date.utc_today())
      conn = get conn, tracker_tracker_path(conn, :prev_date, date)
      assert html_response(conn, 200) =~ "Tracking overview"
    end

    test "/sleep-tracker :: next-date", %{conn: conn} do
      date = Date.to_iso8601(Date.utc_today())
      conn = get conn, tracker_tracker_path(conn, :next_date, date)
      assert html_response(conn, 200) =~ "Tracking overview"
    end
  end

  describe "without current user" do
    setup do
      %User{
          id: 123456,
          first_name: "My",
          last_name: "Name",
          email: "abc@gmail.com",
          password_hash: Comeonin.Bcrypt.hashpwsalt("password")
        } |> Repo.insert
      :ok
    end

    test "conn is halted for index", %{conn: conn} do
      conn = get conn, tracker_path(conn, :index)
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "conn is halted for prev-date",%{conn: conn}  do
      date = Date.to_iso8601(Date.utc_today())
      conn = get conn, tracker_tracker_path(conn, :prev_date, date)
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "conn is halted fo next-date", %{conn: conn} do
      date = Date.to_iso8601(Date.utc_today())
      conn = get conn, tracker_tracker_path(conn, :next_date, date)
      assert html_response(conn, 302)
      assert conn.halted
    end
  end
end
