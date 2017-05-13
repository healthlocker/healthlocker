defmodule Healthlocker.PasswordControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.User
  import Mock
  use Timex

  @existing_email %{
    email: "email@example.com"
  }

  @non_existent_email %{
    email: "nope@email.com"
  }

  @invalid_attrs %{}

  @valid_password %{
    password: "abc123",
    password_confirmation: "abc123"
  }

  @invalid_password %{
    password: "",
    password_confirmation: "ggdc"
  }

  setup do
    %User{
      id: 123456,
      first_name: "My",
      last_name: "Name",
      email: "email@example.com",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      security_question: "Question?",
      security_answer: "Answer",
      slam_id: 1
    } |> Repo.insert

    %User{
      id: 123457,
      first_name: "My",
      last_name: "Name",
      email: "email2@example.com",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      security_question: "Question?",
      security_answer: "Answer",
      slam_id: 1,
      reset_password_token: "uyhjvbrw89iug3j24b298iygjk45b3trge",
      reset_token_sent_at: DateTime.utc_now
    } |> Repo.insert

    :ok
  end

  test "GET /password/new", %{conn: conn} do
    conn = get conn, password_path(conn, :new)
    assert html_response(conn, 200) =~ "Password reset"
  end

  test "POST /password sends password reset email", %{conn: conn} do
    with_mock Healthlocker.Mailer, [deliver_now: fn(_) -> nil end] do
      conn = post conn, password_path(conn, :create), user: @existing_email
      assert redirected_to(conn) == login_path(conn, :index)
      assert get_flash(conn, :info) == "If your email address exists in our database, you will receive a password reset link at your email address in a few minutes."
      user = Repo.get!(User, 123456)
      assert user.reset_token_sent_at
      assert user.reset_password_token
    end
  end

  test "POST /password with non_existent_email", %{conn: conn} do
    conn = post conn, password_path(conn, :create), user: @non_existent_email
    assert redirected_to(conn) == password_path(conn, :new)
    assert get_flash(conn, :error) == "Could not send reset email. Please try again later"
  end

  test "POST /password with invalid data", %{conn: conn} do
    conn = post conn, password_path(conn, :create), user: @invalid_attrs
    assert redirected_to(conn) == password_path(conn, :new)
    assert get_flash(conn, :error) == "Could not send reset email. Please try again later"
  end

  test "GET /password/:id/edit", %{conn: conn} do
    user = Repo.get!(User, 123457)
    conn = get conn, password_path(conn, :edit, user.reset_password_token)
    assert html_response(conn, 200) =~ "Password reset"
  end

  test "GET /password/:id/edit with invalid token", %{conn: conn} do
    conn = get conn, password_path(conn, :edit, "uigwajkfhsopqwe")
    assert redirected_to(conn) == password_path(conn, :new)
    assert get_flash(conn, :error) == "Invalid reset token"
  end

  test "GET /password/:id/edit with expired token", %{conn: conn} do
    user = Repo.get!(User, 123457)
    expired_reset_date = Timex.shift(user.reset_token_sent_at, days: -1)
    user = user
          |> Ecto.Changeset.change(reset_token_sent_at: expired_reset_date)
          |> Repo.update!
    conn = get conn, password_path(conn, :edit, user.reset_password_token)
    user = Repo.get!(User, 123457)
    refute user.reset_token_sent_at
    refute user.reset_password_token
    assert redirected_to(conn) == password_path(conn, :new)
    assert get_flash(conn, :error) == "Password reset token expired"
  end

  test "PUT /password/:id", %{conn: conn} do
    user = Repo.get!(User, 123457)
    conn = put conn, password_path(conn, :update, user.reset_password_token), user: @valid_password
    assert redirected_to(conn) == login_path(conn, :index)
    user = Repo.get!(User, 123457)
    refute user.reset_token_sent_at
    refute user.reset_password_token
    assert get_flash(conn, :info) == "Password reset successfully!"
  end

  test "PUT /password/:id with invalid token", %{conn: conn} do
    conn = put conn, password_path(conn, :update, "uiewgjfbsdyuwergjhs"), user: @valid_password
    assert redirected_to(conn) == password_path(conn, :new)
    assert get_flash(conn, :error) == "Invalid reset token"
  end

  test "PUT /password/:id with expired token", %{conn: conn} do
    user = Repo.get!(User, 123457)
    expired_reset_date = Timex.shift(user.reset_token_sent_at, days: -1)
    user = user
          |> Ecto.Changeset.change(reset_token_sent_at: expired_reset_date)
          |> Repo.update!
    conn = put conn, password_path(conn, :update, user.reset_password_token), user: @valid_password
    user = Repo.get!(User, 123457)
    refute user.reset_token_sent_at
    refute user.reset_password_token
    assert redirected_to(conn) == password_path(conn, :new)
    assert get_flash(conn, :error) == "Password reset token expired"
  end

  test "PUT /password/:id with invalid password", %{conn: conn} do
    user = Repo.get!(User, 123457)
    conn = put conn, password_path(conn, :update, user.reset_password_token), user: @invalid_password
    assert html_response(conn, 200) =~ "Password reset"
  end
end
