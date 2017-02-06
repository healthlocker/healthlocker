defmodule Healthlocker.LoginControllerTest do
  use Healthlocker.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/login"
    assert html_response(conn, 200) =~ "Email"
  end

  test 
end
