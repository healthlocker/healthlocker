defmodule Healthlocker.TermControllerTest do
  use Healthlocker.ConnCase

  test "GET /terms-and-conditions", %{conn: conn} do
    conn = get conn, term_path(conn, :index)
    assert html_response(conn, 200) =~ "Terms and conditions"
  end
end
