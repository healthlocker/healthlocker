defmodule Healthlocker.SupportControllerTest do
  use Healthlocker.ConnCase

  test "GET /support", %{conn: conn} do
    conn = get conn, "/support"
    assert html_response(conn, 200) =~ "Get Support"
  end
end
