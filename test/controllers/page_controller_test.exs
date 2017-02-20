defmodule Healthlocker.PageControllerTest do
  use Healthlocker.ConnCase
  import Healthlocker.Fixtures

  test "gets page when there are no stories or tips", %{conn: conn} do
    conn = get conn, page_path(conn, :index)
    assert html_response(conn, 200) =~ "No stories found"
    assert html_response(conn, 200) =~ "No tips found"
  end

  test "GET /", %{conn: conn} do
    fixture(:post)
    conn = get conn, page_path(conn, :index)
    assert html_response(conn, 200) =~ "Home"
  end
end
