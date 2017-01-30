defmodule Healthlocker.TipControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.Tip
  @valid_attrs %{tag: "some content", value: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, tip_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing tips"
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

  test "shows chosen resource", %{conn: conn} do
    tip = Repo.insert! %Tip{}
    conn = get conn, tip_path(conn, :show, tip)
    assert html_response(conn, 200) =~ "Show tip"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, tip_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    tip = Repo.insert! %Tip{}
    conn = get conn, tip_path(conn, :edit, tip)
    assert html_response(conn, 200) =~ "Edit tip"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    tip = Repo.insert! %Tip{}
    conn = put conn, tip_path(conn, :update, tip), tip: @valid_attrs
    assert redirected_to(conn) == tip_path(conn, :show, tip)
    assert Repo.get_by(Tip, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    tip = Repo.insert! %Tip{}
    conn = put conn, tip_path(conn, :update, tip), tip: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit tip"
  end

  test "deletes chosen resource", %{conn: conn} do
    tip = Repo.insert! %Tip{}
    conn = delete conn, tip_path(conn, :delete, tip)
    assert redirected_to(conn) == tip_path(conn, :index)
    refute Repo.get(Tip, tip.id)
  end
end
