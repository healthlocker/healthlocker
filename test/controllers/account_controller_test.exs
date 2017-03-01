defmodule Healthlocker.AccountControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.User

  @valid_attrs %{
    name: "NewName",
    security_check: "Answer",
    security_question: "?",
    security_answer: "yes",
    password_check: "password",
    password: "New password",
    password_confirmation: "New password"
  }
  @invalid_attrs %{
    name: "",
    email: "",
    phone_number: "",
    security_check: "Answer",
    security_question: "",
    security_answer: "",
    password_check: "password",
    password: 1
  }
  @wrong_security_answer %{
    security_check: "Wrong answer",
    security_question: "?",
    security_answer: "yes"
  }
  @wrong_password %{
    password_check: "Wrong password",
    password: "New password",
    password_confirmation: "New password"
  }
  @wrong_confirmation %{
    password_check: "password",
    password: "New password",
    password_confirmation: "not new password"
  }

  describe "all account paths need current_user for access" do
    setup do
      %User{
        id: 123456,
        name: "MyName",
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer"
      } |> Repo.insert

      {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123456)) }
    end

    test "renders index.html on /account", %{conn: conn} do
      conn = get conn, account_path(conn, :index)
      assert html_response(conn, 200) =~ "Account"
    end

    test "update user with valid data", %{conn: conn} do
      conn = put conn, account_path(conn, :update), user: @valid_attrs
      assert redirected_to(conn) == account_path(conn, :index)
    end

    test "does not update user when data is invalid", %{conn: conn} do
      conn = put conn, account_path(conn, :update), user: @invalid_attrs
      assert html_response(conn, 200) =~ "Account"
    end

    test "renders consent.html on /account/consent", %{conn: conn} do
      conn = get conn, account_path(conn, :consent)
      assert html_response(conn, 200) =~ "anonymous data"
    end

    test "renders slam.html on /account/slam", %{conn: conn} do
      conn = get conn, account_path(conn, :slam)
      assert html_response(conn, 200) =~ "Please use the correct information as it appears on your health record."
    end

    test "updates user data_access with valid data", %{conn: conn} do
      conn = put conn, account_path(conn, :update_consent), user: %{data_access: true}
      assert redirected_to(conn) == account_path(conn, :index)
    end

    test "render security.html", %{conn: conn} do
      conn = get conn, account_path(conn, :security)
      assert html_response(conn, 200) =~ "Update security question"
    end

    test "render edit_security.html", %{conn: conn} do
      conn = get conn, account_path(conn, :edit_security)
      assert html_response(conn, 200) =~ "Current security question"
    end

    test "updates security question and answer when data is valid", %{conn: conn} do
      conn = put conn, account_path(conn, :update_security), user: @valid_attrs
      assert redirected_to(conn) == account_path(conn, :edit_security)
    end

    test "does not update when security answer is incorrect", %{conn: conn} do
      conn = put conn, account_path(conn, :update_security), user: @wrong_security_answer
      assert redirected_to(conn) == account_path(conn, :edit_security)
      assert get_flash(conn, :error) == "Security answer does not match"
    end

    test "does not update when data is invalid", %{conn: conn} do
      conn = put conn, account_path(conn, :update_security), user: @invalid_attrs
      assert html_response(conn, 200) =~ "Current security question"
    end

    test "render edit_password.html", %{conn: conn} do
      conn = get conn, account_path(conn, :edit_password)
      assert html_response(conn, 200) =~ "Current password"
    end

    test "does not update when current password is incorrect", %{conn: conn} do
      conn = put conn, account_path(conn, :update_password), user: @wrong_password
      assert redirected_to(conn) == account_path(conn, :edit_password)
      assert get_flash(conn, :error) == "Incorrect current password"
    end

    test "updates password with valid data", %{conn: conn} do
      conn = put conn, account_path(conn, :update_password), user: @valid_attrs
      assert redirected_to(conn) == account_path(conn, :edit_password)
      refute get_flash(conn, :error) == "Incorrect current password"
    end

    test "does not update password when data is invalid", %{conn: conn} do
      conn = put conn, account_path(conn, :update_password), user: @invalid_attrs
      assert html_response(conn, 200) =~ "Current password"
    end

    test "does not update password when confirmation does not match", %{conn: conn} do
      conn = put conn, account_path(conn, :update_password), user: @wrong_confirmation
      assert html_response(conn, 200) =~ "Current password"
    end

    test "render nhs_help.html", %{conn: conn} do
      conn = get conn, account_path(conn, :nhs_help)
      assert html_response(conn, 200) =~ "Your NHS number will be on any letter"
    end
  end

  describe "connection is halted if there is no current_user" do
    test "index", %{conn: conn} do
      conn = get conn, account_path(conn, :index)
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "update", %{conn: conn} do
      conn = put conn, account_path(conn, :update), user: @valid_attrs
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "consent", %{conn: conn} do
      conn = get conn, account_path(conn, :consent)
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "slam", %{conn: conn} do
      conn = get conn, account_path(conn, :slam)
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "update user data_access", %{conn: conn} do
      conn = put conn, account_path(conn, :update_consent), user: %{data_access: true}
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "nhs_help will halt the conn & redirect", %{conn: conn} do
      conn = get conn, account_path(conn, :nhs_help)
      assert html_response(conn, 302)
      assert conn.halted
    end
  end
end
