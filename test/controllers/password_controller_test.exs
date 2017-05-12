defmodule Healthlocker.PasswordControllerTest do
  use Healthlocker.ConnCase

  test "GET /password/new", %{conn: conn} do
    conn = get conn, password_path(conn, :new)
    assert html_response(conn, 200) =~ "Password reset"
  end
end
