defmodule Healthlocker.CopingStrategyControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.Post
  alias Healthlocker.User


  @valid_attrs %{content: "some content"}
  @invalid_attrs %{content: ""}

  describe "coping strategy routes need current_user to access" do
    setup do
      %User{
        id: 123456,
        name: "MyName",
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password")
        } |> Repo.insert

        {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123456)) }
    end

    test "renders index.html on /coping-strategy", %{conn: conn} do
      conn = get conn, coping_strategy_path(conn, :index)
      assert html_response(conn, 200) =~ "Coping strategies"
    end

    test "shows chosen coping strategy", %{conn: conn} do
      coping_strategy = Repo.insert! %Post{content: "some content",  user_id: 123456}
      conn = get conn, coping_strategy_path(conn, :show, coping_strategy)
      assert html_response(conn, 200) =~ "Toolkit"
    end

    test "renders page not found when coping strategy id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, coping_strategy_path(conn, :show, -1)
      end
    end

    test "renders form for new coping strategy", %{conn: conn} do
      conn = get conn, coping_strategy_path(conn, :new)
      assert html_response(conn, 200) =~ "Add new"
    end

    test "creates coping strategy and redirects when data is valid", %{conn: conn} do
      conn = post conn, coping_strategy_path(conn, :create), post: @valid_attrs
      assert redirected_to(conn) == coping_strategy_path(conn, :index)
      assert Repo.get_by(Post, content: "some content #CopingStrategy")
    end

    test "does not create coping strategy and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, coping_strategy_path(conn, :create), post: @invalid_attrs
      assert html_response(conn, 200) =~ "Add new"
    end

    test "renders form for editing coping strategy", %{conn: conn} do
      coping_strategy = Repo.insert %Post{content: "some content #CopingStrategy", user_id: 123456}
      conn = get conn, coping_strategy_path(conn, :edit, elem(coping_strategy, 1))
      assert html_response(conn, 200) =~ "Edit coping strategy"
    end

    test "updates coping strategy with valid data", %{conn: conn} do
      coping_strategy = Repo.insert! %Post{content: "some stuff"}
      conn = put conn, coping_strategy_path(conn, :update, coping_strategy), post: @valid_attrs
      assert redirected_to(conn) == coping_strategy_path(conn, :show, coping_strategy)
    end

    test "does not update coping strategy when data is invalid", %{conn: conn} do
      coping_strategy = Repo.insert! %Post{content: "some stuff"}
      conn = put conn, coping_strategy_path(conn, :update, coping_strategy), post: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit coping strategy"
    end

    test "delete chosen coping strategy", %{conn: conn} do
      coping_strategy = Repo.insert! %Post{content: "some content", user_id: 123456}
      conn = delete conn, coping_strategy_path(conn, :delete, coping_strategy)
      assert redirected_to(conn) == coping_strategy_path(conn, :index)
    end
  end

  describe "conn is halted if there is no current_user" do
    test "index", %{conn: conn} do
      conn = get conn, coping_strategy_path(conn, :index)
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "new", %{conn: conn} do
      conn = get conn, coping_strategy_path(conn, :new)
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "create", %{conn: conn} do
      conn = post conn, coping_strategy_path(conn, :create), post: @valid_attrs
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "update", %{conn: conn} do
      coping_strategy = Repo.insert! %Post{content: "some stuff"}
      conn = put conn, coping_strategy_path(conn, :update, coping_strategy), post: @valid_attrs
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

      {:ok, coping_strategy: Repo.insert! %Post{content: "some content",  user_id: 123456}}
    end

    test "show", %{conn: conn, coping_strategy: coping_strategy} do
      conn = get conn, coping_strategy_path(conn, :show, coping_strategy)
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "edit", %{conn: conn} do
      coping_strategy = Repo.insert %Post{content: "some content #CopingStrategy", user_id: 123456}
      conn = get conn, coping_strategy_path(conn, :edit, elem(coping_strategy, 1))
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "delete", %{conn: conn, coping_strategy: coping_strategy} do
      conn = delete conn, coping_strategy_path(conn, :delete, coping_strategy)
      assert html_response(conn, 302)
      assert conn.halted
    end
  end
end
