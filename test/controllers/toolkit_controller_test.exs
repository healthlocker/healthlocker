defmodule Healthlocker.ToolkitControllerTest do
  use Healthlocker.ConnCase

  test "renders index.html on /toolkit", %{conn: conn} do
    conn = get conn, toolkit_path(conn, :index)
    assert html_response(conn, 200) =~ "Toolkit"
  end
end
