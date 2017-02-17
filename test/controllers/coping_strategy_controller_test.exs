defmodule Healthlocker.CopingStrategyController do
  use Healthlocker.ConnCase

  alias Healthlocker.Post

  @valid_attrs %{content: "some content"}
  @invalid_attrs %{}

  test "renders index.html on /coping-strategy", %{conn: conn} do
    conn = get conn, coping_strategy_path(conn, :index)
    assert html_response(conn, 200) =~ "Coping strategies"
  end

  test "shows chosen coping strategy", %{conn: conn} do
    coping_strategy = Repo.insert! %Post{content: "some content"}
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
    assert Repo.get_by(Post, @valid_attrs)
  end

  test "does not create coping strategy and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, coping_strategy_path(conn, :create), post: @invalid_attrs
    assert html_response(conn, 200) =~ "Add new"
  end

  test "renders form for editing coping strategy", %{conn: conn} do
    coping_strategy = Repo.insert %Post{content: "some content"}
    conn = get conn, coping_strategy_path(conn, :edit, coping_strategy)
    assert html_response(conn, 200) =~ "Edit coping strategy"
  end

  test "updates coping strategy with valid data", %{conn: conn} do
    coping_strategy = Repo.insert %Post{content: "some stuff"}
    conn = put conn, coping_strategy_path(conn, :update, coping_strategy), post: @invalid_attrs
    assert redirected_to(conn) == coping_strategy_path(conn, :show, coping_strategy)
  end

  test "does not update coping strategy when data is invalid", %{conn: conn} do
    coping_strategy = Repo.insert! %Post{content: "some stuff"}
    conn = put conn, coping_strategy_path(conn, update: coping_strategy), post: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit coping strategy"
  end

  test "delete chosen coping strategy", %{conn: conn} do
    coping_strategy = Repo.insert! %Post{content: "some content"}
    conn = delete conn, coping_strategy_path(conn, :delete, coping_strategy)
    assert redirected_to(conn) == coping_strategy_path(conn, :show, coping_strategy)
  end
end
