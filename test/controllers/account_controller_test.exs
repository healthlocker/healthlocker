defmodule Healthlocker.AccountControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.User

  setup do
    %User{
      id: 123456,
      name: "MyName",
      email: "abc@gmail.com",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      security_question: "Question?",
      security_answer: "Answer"
    } |> Repo.insert

    {:ok, user: Repo.get(User, 123456) }
  end

  @valid_attrs %{name: "NewName"}
  @invalid_attrs %{
    name: "",
    email: "",
    phone_number: "",
    security_check: "Answer",
    security_question: "",
    security_answer: ""
  }
  @valid_security_update %{
    security_question: "2",
    security_answer: "yes"
  }

  test "renders index.html on /account", %{conn: conn, user: user} do
    conn = build_conn()
        |> assign(:current_user, user)
        |> get(account_path(conn, :index))
    assert html_response(conn, 200) =~ "Account"
  end

  test "update user with valid data", %{conn: conn, user: user} do
    conn = build_conn()
          |> assign(:current_user, user)
          |> put(account_path(conn, :update), user: @valid_attrs)
    assert redirected_to(conn) == account_path(conn, :index)
  end

  test "does not update user when data is invalid", %{conn: conn, user: user} do
    conn = build_conn()
          |> assign(:current_user, user)
          |> put(account_path(conn, :update), user: @invalid_attrs)
    assert html_response(conn, 200) =~ "Account"
  end

  test "render security.html", %{conn: conn, user: user} do
    conn = build_conn()
        |> assign(:current_user, user)
        |> get(account_path(conn, :security))
    assert html_response(conn, 200) =~ "Security"
  end

  test "render edit_security.html", %{conn: conn, user: user} do
    conn = build_conn()
        |> assign(:current_user, user)
        |> get(account_path(conn, :edit_security))
    assert html_response(conn, 200) =~ "Current security question"
  end

  test "updates security question and answer when data is valid", %{conn: conn, user: user} do
    conn = build_conn()
          |> assign(:current_user, user)
          |> put(account_path(conn, :update_security), user: @valid_security_update)
    assert redirected_to(conn) == account_path(conn, :edit_security)
  end

  test "does not update when security answer is incorrect", %{conn: conn, user: user} do
    conn = build_conn()
          |> assign(:current_user, user)
          |> put(account_path(conn, :update_security), user: @valid_security_update)
    assert redirected_to(conn) == account_path(conn, :edit_security)
    assert get_flash(conn, :error) == "Security answer does not match"
  end

  test "does not update when data is invalid", %{conn: conn, user: user} do
    conn = build_conn()
          |> assign(:current_user, user)
          |> put(account_path(conn, :update_security), user: @invalid_attrs)
    assert html_response(conn, 200) =~ "Current security question"
  end
end
