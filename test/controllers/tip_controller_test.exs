defmodule Healthlocker.TipControllerTest do
  use Healthlocker.ConnCase

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, tip_path(conn, :index)
    assert html_response(conn, 200) =~ "Tips"
  end

end
