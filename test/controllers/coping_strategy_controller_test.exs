defmodule Healthlocker.CopingStrategyController do
  use Healthlocker.ConnCase

  alias Healthlocker.Post

  @valid_attrs %{content: "some content"}

  test "renders index.html on /coping-strategy", %{conn: conn} do
    conn = get conn, coping_strategy_path(conn, :index)
    assert html_response(conn, 200) =~ "Coping strategies"
  end

  test "renders form for new name and email", %{conn: conn} do
    conn = get conn, coping_strategy_path(conn, :new)
    assert html_response(conn, 200) =~ "Add new"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, coping_strategy_path(conn, :create), post: @valid_attrs
    assert redirected_to(conn) == coping_strategy_path(conn, :index)
    assert Repo.get_by(Post, @valid_attrs)
  end
end
