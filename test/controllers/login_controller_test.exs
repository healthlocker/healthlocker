defmodule Healthlocker.LoginControllerTest do
  use Healthlocker.ConnCase
  alias Healthlocker.User

  @valid_attrs %{
    email: "abc@gmail.com",
    password: "password"
  }

  test "GET /", %{conn: conn} do
    conn = get conn, "/login"
    assert html_response(conn, 200) =~ "Email"
  end

  describe "with valid data for user who has completed all sign up steps" do
    setup do
      %User{
        id: 123456,
        name: "MyName",
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        data_access: false
      } |> Repo.insert

      :ok
    end

    test "/login :: create", %{conn: conn} do
      conn = post conn, login_path(conn, :create), login: @valid_attrs
      assert get_flash(conn, :info) == "Welcome to Healthlocker!"
      assert redirected_to(conn) == toolkit_path(conn, :index)
    end

    test "/login :: delete", %{conn: conn} do
      user = Repo.get(User, 123456)
      conn = delete conn, login_path(conn, :delete, user)
      assert redirected_to(conn) == page_path(conn, :index)
    end
  end

  describe "with valid data for user who has completed sign up steps 1&2" do
    setup do
      %User{
        id: 123456,
        name: "MyName",
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer"
      } |> Repo.insert

      :ok
    end

    test "/login :: create", %{conn: conn} do
      user = Repo.get(User, 123456)
      conn = post conn, login_path(conn, :create), login: @valid_attrs
      assert get_flash(conn, :error) == "You must accept terms of service and privacy statement"
      assert redirected_to(conn) == user_user_path(conn, :signup3, user)
    end
  end

  describe "without signed up user" do
    test "/login :: create", %{conn: conn} do
      conn = post conn, login_path(conn, :create), login: @valid_attrs
      assert get_flash(conn, :error) == "Invalid email/password combination"
      assert html_response(conn, 200) =~ "Email"
    end
  end
end
