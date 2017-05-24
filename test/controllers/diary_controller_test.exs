defmodule Healthlocker.DiaryControllerTest do
  use Healthlocker.ConnCase
  alias Healthlocker.{User, Diary}

  @valid_attrs %{entry: "a problem"}
  @invalid_attrs %{entry: ""}

  describe "No user logged in" do
    test "GET /diary/new gets redirected", %{conn: conn} do
      conn = get conn, diary_path(conn, :new)
      assert html_response(conn, 302)
    end
  end

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

    test "GET /diary/new", %{conn: conn} do
      conn = get conn, diary_path(conn, :new)
      assert html_response(conn, 200) =~ "Diary"
    end

    test "POST /diary with correct details", %{conn: conn} do
      conn = post conn, diary_path(conn, :create), diary: @valid_attrs
      assert redirected_to(conn) == toolkit_path(conn, :index)
    end

    test "POST /diary with invalid_attrs ", %{conn: conn} do
      conn = post conn, diary_path(conn, :create), diary: @invalid_attrs
      assert html_response(conn, 200) =~ "Diary"
    end
  end

  describe "Current user is assigned to the conn and has created a diary entry for a past day" do
    setup do
      %User{
        id: 123456,
        first_name: "My",
        last_name: "Name",
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password")
      } |> Repo.insert
      %Diary{
        id: 654321,
        entry: "my diary entry",
        user_id: 123456,
        inserted_at: Timex.shift(DateTime.utc_now(), days: -1),
        updated_at: Timex.shift(DateTime.utc_now(), days: -1)
      } |> Repo.insert

      {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123456)) }
    end

    test "GET /diary/new", %{conn: conn} do
      conn = get conn, diary_path(conn, :new)
      assert html_response(conn, 200) =~ "Diary"
    end
  end

  describe "Current user is assigned to the conn and has created a diary entry for today" do
    setup do
      %User{
        id: 123456,
        first_name: "My",
        last_name: "Name",
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password")
      } |> Repo.insert
      %Diary{
        id: 654321,
        entry: "my diary entry",
        user_id: 123456,
        inserted_at: DateTime.utc_now(),
        updated_at: DateTime.utc_now()
      } |> Repo.insert

      {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123456)) }
    end

    test "GET /diary/new with a diary entry for today goes to edit", %{conn: conn} do
      diary = Repo.get(Diary, 654321)
      conn = get conn, diary_path(conn, :new)
      assert redirected_to(conn) == diary_path(conn, :edit, diary)
    end

    test "PUT /diary/:id to update an entry", %{conn: conn} do
      diary = Repo.get(Diary, 654321)
      conn = put conn, diary_path(conn, :update, diary), diary: @valid_attrs
      assert redirected_to(conn) == toolkit_path(conn, :index)
    end

    test "PUT /diary/:id to update an entry with incorrect details will not work", %{conn: conn} do
      diary = Repo.get(Diary, 654321)
      conn = put conn, diary_path(conn, :update, diary), diary: @invalid_attrs
      assert html_response(conn, 200) =~ "Diary"
    end
  end
end
