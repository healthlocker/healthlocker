defmodule Healthlocker.PageControllerTest do
  use Healthlocker.ConnCase
  import Healthlocker.Fixtures

  test "gets page when there are no stories or tips", %{conn: conn} do
    conn = get conn, page_path(conn, :index)
    assert html_response(conn, 200) =~ "No stories found"
  end

  test "GET /", %{conn: conn} do
    fixture(:post)
    conn = get conn, page_path(conn, :index)
    assert html_response(conn, 200) =~ "Wellbeing Tips"
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
    assert html_response(conn, 200) =~ "Terms of Service"
  end

  test "render security.html on /pages/security", %{conn: conn} do
    conn = get conn, page_path(conn, :show, "security")
    assert html_response(conn, 200) =~ "Update security question"
  end

  test "render nhs_help.html on /pages/nhs_help", %{conn: conn} do
    conn = get conn, page_path(conn, :show, "nhs_help")
    assert html_response(conn, 200) =~ "Your NHS number will be on any letter"
  end

  test "renders connecting slam info on /pages/slam_help", %{conn: conn} do
    conn = get conn, page_path(conn, :show, "slam_help")
    assert html_response(conn, 200) =~ "To connect you will need to enter"
  end

  test "On / the word Home in the nav bar is bold", %{conn: conn} do
    conn = get conn, page_path(conn, :index)
    assert html_response(conn, 200) =~ "<a class=\"pb3 pt4 pt5-l f3 white-80 db hover-white b\" href=\"/\">Home</a>"
  end
end
