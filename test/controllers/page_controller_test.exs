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

  test "renders about.html on /pages/about", %{conn: conn} do
    conn = get conn, page_path(conn, :show, "about")
    assert html_response(conn, 200) =~ "About"
  end

  test "renders privacy.html on /pages/privacy", %{conn: conn} do
    conn = get conn, page_path(conn, :show, "privacy")
    assert html_response(conn, 200) =~ "Privacy Statement"
  end

  test "renders terms.html on /pages/terms-and-conditions", %{conn: conn} do
    conn = get conn, page_path(conn, :show, "terms")
    assert html_response(conn, 200) =~ "Terms and conditions"
  end
end
