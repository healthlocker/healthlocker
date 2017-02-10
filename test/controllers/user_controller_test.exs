defmodule Healthlocker.UserControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.User
  @step1_attrs %{
    email: "me@example.com",
    name: "MyName"
  }
  @invalid_attrs %{}

  test "loads index.html on /users", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert html_response(conn, 200) =~ "Welcome! Get started by adding new content"
  end

  test "renders form for new name and email", %{conn: conn} do
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "New user"
  end

  test "renders form for new user password and security Q&A", %{conn: conn} do
    conn =
      case Repo.insert %User{
        email: "me@example.com",
        name: "MyName"
        } do
          {:ok, user} ->
            get conn, "/users/#{user.id}/signup2"
          end
    assert html_response(conn, 200) =~ "Password"
  end

  test "renders form for accepting T&Cs, privacy, and data access request", %{conn: conn} do
    conn =
      case Repo.insert %User{
        email: "me@example.com",
        password: "password",
        security_question: "Favourite food?",
        security_answer: "pizza"
      } do
        {:ok, user} ->
          get conn, "/users/#{user.id}/signup3"
      end
    assert html_response(conn, 200) =~ "terms and conditions"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @step1_attrs
    user = Repo.get_by(User, email: "me@example.com")
    assert redirected_to(conn) == "/users/#{user.id}/signup2"
    assert user
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "New user"
  end
end
