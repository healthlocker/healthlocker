defmodule Healthlocker.PageControllerTest do
  use Healthlocker.ConnCase
  import Healthlocker.Fixtures

  test "GET /", %{conn: conn} do
    fixture(:post)
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Home"
  end
end
