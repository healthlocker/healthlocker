defmodule Healthlocker.TipControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.Tip
  @valid_attrs %{tag: "some content", value: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, tip_path(conn, :index)
    assert html_response(conn, 200) =~ "Tips"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, tip_path(conn, :new)
    assert html_response(conn, 200) =~ "New tip"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, tip_path(conn, :create), tip: @valid_attrs
    assert redirected_to(conn) == tip_path(conn, :index)
    assert Repo.get_by(Tip, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, tip_path(conn, :create), tip: @invalid_attrs
    assert html_response(conn, 200) =~ "New tip"
  end

end
