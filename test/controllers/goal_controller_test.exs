defmodule Healthlocker.GoalControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.Post
  alias Healthlocker.User

  @valid_attrs %{content: "some content"}
  @invalid_attrs %{content: ""}

  describe "goal routes need current_user to access" do
    setup do
      %User{
        id: 123456,
        name: "MyName",
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password")
      } |> Repo.insert

      {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123456)) }
    end

    test "renders index.html on /goal", %{conn: conn} do
      conn = get conn, goal_path(conn, :index)
      assert html_response(conn, 200) =~ "Goals"
    end

    test "shows chosen goal", %{conn: conn} do
      goal = Repo.insert! %Post{content: "some content",  user_id: 123456}
      conn = get conn, goal_path(conn, :show, goal)
      assert html_response(conn, 200) =~ "Toolkit"
    end

    test "renders page not found when goal id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        conn = get conn, goal_path(conn, :show, -1)
      end
    end

    test "renders form for new goal", %{conn: conn} do
      conn = get conn, goal_path(conn, :new)
      assert html_response(conn, 200) =~ "Add new"
    end

    test "creates goal and redirects when data is valid", %{conn: conn} do
      conn = post conn, goal_path(conn, :create), post: @valid_attrs
      assert redirected_to(conn) == goal_path(conn, :index)
      assert Repo.get_by(Post, content: "some content #Goal")
    end

    test "does not create goal and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, goal_path(conn, :create), post: @invalid_attrs
      assert html_response(conn, 200) =~ "Add new"
    end

    test "renders form for editing goal", %{conn: conn} do
      goal = Repo.insert %Post{content: "some content #Goal", user_id: 123456}
      conn = get conn, goal_path(conn, :edit, elem(goal, 1))
      assert html_response(conn, 200) =~ "Edit goal"
    end

    test "updates goal with valid data", %{conn: conn} do
      goal = Repo.insert! %Post{content: "some stuff"}
      conn = put conn, goal_path(conn, :update, goal), post: @valid_attrs
      assert redirected_to(conn) == goal_path(conn, :show, goal)
    end

    test "does not update goal when data is invalid", %{conn: conn} do
      goal = Repo.insert! %Post{content: "some stuff"}
      conn = put conn, goal_path(conn, :update, goal), post: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit goal"
    end

    test "delete chosen goal", %{conn: conn} do
      goal = Repo.insert! %Post{content: "some content", user_id: 123456}
      conn = delete conn, goal_path(conn, :delete, goal)
      assert redirected_to(conn) == goal_path(conn, :index)
    end
  end

  describe "conn is halted if there is no current_user" do
    test "index", %{conn: conn} do
      conn = get conn, goal_path(conn, :index)
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "new", %{conn: conn} do
      conn = get conn, goal_path(conn, :new)
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "create", %{conn: conn} do
      conn = post conn, goal_path(conn, :create), post: @valid_attrs
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "update", %{conn: conn} do
      goal = Repo.insert! %Post{content: "some stuff"}
      conn = put conn, goal_path(conn, :update, goal), post: @valid_attrs
      assert html_response(conn, 302)
      assert conn.halted
    end
  end

  describe "conn is halted if there is no current_user and foreign key constraints match" do
    setup do
      %User{
        id: 123456,
        name: "MyName",
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password")
        } |> Repo.insert

      {:ok, goal: Repo.insert! %Post{content: "some content", user_id: 123456}}
    end

    test "show", %{conn: conn, goal: goal} do
      conn = get conn, goal_path(conn, :show, goal)
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "edit", %{conn: conn} do
      goal = Repo.insert %Post{content: "some content #Goal", user_id: 123456}
      conn = get conn, goal_path(conn, :edit, elem(goal, 1))
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "delete", %{conn: conn, goal: goal} do
      conn = delete conn, goal_path(conn, :delete, goal)
      assert html_response(conn, 302)
      assert conn.halted
    end
  end
end
