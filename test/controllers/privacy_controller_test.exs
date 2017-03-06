defmodule Healthlocker.PrivacyControllerTest do
  use Healthlocker.ConnCase

  test "GET /privacy", %{conn: conn} do
    conn = get conn, privacy_path(conn, :index)
    assert html_response(conn, 200) =~ "Privacy Statement"
  end
end
