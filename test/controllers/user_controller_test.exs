defmodule Healthlocker.UserControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.User
  @valid_attrs %{
    email: "me@example.com",
    password: "abc123",
    name: "MyName",
    security_question: "Favourite animal?",
    security_answer: "Cat",
    data_access: true,
    role: "service user"
  }
  @invalid_attrs %{}

  test "loads index.html on /users", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert html_response(conn, 200) =~ "Welcome! Get started by adding new content"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "New user"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    assert html_response(conn, 200) =~ "Password"
    assert Repo.get_by(User, email: "me@example.com")
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "New user"
  end

end
