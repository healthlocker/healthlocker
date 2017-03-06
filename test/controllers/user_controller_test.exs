defmodule Healthlocker.UserControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.User
  @step1_attrs %{
    email: "me@example.com",
    name: "MyName"
  }
  @step2_attrs %{password: "abc123",
   password_confirmation: "abc123",
   security_answer: "B658H",
   security_question: "4"}
  @step3_attrs %{
    terms_conditions: true,
    privacy: true,
    data_access: true
  }
  @invalid_attrs %{}

  test "loads index.html on /users", %{conn: conn} do
    Repo.insert %User{
      id: 123456,
      name: "MyName",
      email: "abc@gmail.com",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      security_question: "Question?",
      security_answer: "Answer"
    }
    conn = build_conn()
          |> assign(:current_user, Repo.get(User, 123456))
          |> get(user_path(conn, :index))
    assert html_response(conn, 200) =~ "Welcome! Get started by adding new content"
  end

  test "renders form for new name and email", %{conn: conn} do
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "Sign up"
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

  test "creates resource and redirects when data is valid and not duplicate", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @step1_attrs
    user = Repo.get_by(User, email: "me@example.com")
    assert redirected_to(conn) == "/users/#{user.id}/signup2"
    assert user
  end

  test "does not create duplicate resource and redirects when email is duplicate", %{conn: conn} do
    Repo.insert %User{email: "me@example.com"}
    conn = post conn, user_path(conn, :create), user: @step1_attrs
    user = Repo.get_by(User, email: "me@example.com")
    assert redirected_to(conn) == "/users/#{user.id}/signup2"
  end

  test "does not create duplicate resource and redirects when user has completed step1 & 2 of signup", %{conn: conn} do
    Repo.insert %User{email: "me@example.com", password_hash: Comeonin.Bcrypt.hashpwsalt("password")}
    conn = post conn, user_path(conn, :create), user: @step1_attrs
    user = Repo.get_by(User, email: "me@example.com")
    assert redirected_to(conn) == "/users/#{user.id}/signup3"
  end

  test "does not create duplicate resource and redirects when user has previously signed up with false data_access", %{conn: conn} do
    Repo.insert %User{email: "me@example.com", password_hash: Comeonin.Bcrypt.hashpwsalt("password"), data_access: false}
    conn = post conn, user_path(conn, :create), user: @step1_attrs
    assert redirected_to(conn) == login_path(conn, :index)
  end

  test "does not create duplicate resource and redirects when user has previously signed up with true data_access", %{conn: conn} do
    Repo.insert %User{email: "me@example.com", password_hash: Comeonin.Bcrypt.hashpwsalt("password"), data_access: true}
    conn = post conn, user_path(conn, :create), user: @step1_attrs
    assert redirected_to(conn) == login_path(conn, :index)
  end

  test "creates resource and redirects when only email is input", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: %{email: "user@mail.com"}
    user = Repo.get_by(User, email: "user@mail.com")
    assert redirected_to(conn) == "/users/#{user.id}/signup2"
    assert user
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "Sign up"
  end

  test "update resourse with password, security Q&A and redirects when data is valid", %{conn: conn} do
    Repo.insert %User{email: "me@example.com"}
    user = Repo.get_by(User, email: "me@example.com")
    conn = put conn, "/users/#{user.id}/#{:create2}", user: @step2_attrs
    assert redirected_to(conn) == "/users/#{user.id}/signup3"
  end

  test "does not update resource with password, security Q&A and renders errors when data is invalid", %{conn: conn} do
    Repo.insert %User{email: "me@example.com"}
    user = Repo.get_by(User, email: "me@example.com")
    conn = put conn, "/users/#{user.id}/#{:create2}", user: @invalid_attrs
    assert html_response(conn, 200) =~ "Password"
  end

  test "update resourse with data_access and redirects when data is valid", %{conn: conn} do
    Repo.insert %User{
      email: "me@example.com",
      password: "password",
      security_question: "Favourite food?",
      security_answer: "pizza"
    }
    user = Repo.get_by(User, email: "me@example.com")
    conn = put conn, "/users/#{user.id}/#{:create3}", user: @step3_attrs
    assert redirected_to(conn) == toolkit_path(conn, :index)
  end

  test "does not update resource with data_access and renders errors when data is invalid", %{conn: conn} do
    Repo.insert %User{email: "me@example.com"}
    user = Repo.get_by(User, email: "me@example.com")
    conn = put conn, "/users/#{user.id}/#{:create3}", user: @invalid_attrs
    assert html_response(conn, 200) =~ "terms and conditions"
  end
end
