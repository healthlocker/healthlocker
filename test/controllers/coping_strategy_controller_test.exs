defmodule Healthlocker.CopingStrategyController do
  use Healthlocker.ConnCase

  alias Healthlocker.Post

  @valid_attrs %{content: "some content"}

  test "renders index.html on /coping-strategy", %{conn: conn} do
    conn = get conn, coping_strategy_path(conn, :index)
    assert html_response(conn, 200) =~ "Coping strategies"
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

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, coping_strategy_path(conn, :create), post: @valid_attrs
    assert redirected_to(conn) == coping_strategy_path(conn, :index)
    assert Repo.get_by(Post, @valid_attrs)
  end

  test "renders form for editing coping strategy", %{conn: conn} do
    Repo.insert %Post{content: "some content"}
    coping_strategy = Repo.get_by(Post, content: "some content")
    conn = get conn, coping_strategy_path(conn, :edit, coping_strategy: coping_strategy)
    assert html_response(conn, 200) =~ "Edit coping strategy"
  end

  test "updates coping strategy", %{conn: conn} do
    Repo.insert %Post{content: "some content"}
    coping_strategy = Repo.get_by(Post, content: "some content")
    conn = put conn, coping_strategy_path(conn, :update, coping_strategy: coping_strategy)
    assert redirected_to(conn) == coping_strategy_path(conn, :show, coping_strategy: coping_strategy)
  end
end
