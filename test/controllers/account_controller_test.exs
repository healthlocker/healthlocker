defmodule Healthlocker.AccountControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.{User, EPJSUser, ReadOnlyRepo}

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
    email: "a",
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

  @slam_attrs %{
    "Forename" => "Kat",
    "Surname" => "Bow",
    "NHS_Number" => "uvhjbfnwqoekhfg8y9i",
    "DOB" => "01/01/1989"
  }

  describe "current_user is assigned in the session" do
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

    test "renders index.html", %{conn: conn} do
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
      assert redirected_to(conn) == account_path(conn, :consent)
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
      assert html_response(conn, 200) =~ "Current security question"
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
      assert html_response(conn, 200) =~ "Current password"
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

    test "check_slam renders index with correct details", %{conn: conn} do
      dob = DateTime.from_naive!(~N[1989-01-01 00:00:00.00], "Etc/UTC")
      ReadOnlyRepo.insert!(%EPJSUser{
        id: 789,
        Patient_ID: 200,
        Surname: "Bow",
        Forename: "Kat",
        NHS_Number: "uvhjbfnwqoekhfg8y9i",
        DOB: dob,
      })
      conn = put conn, account_path(conn, :check_slam), user: @slam_attrs
      assert html_response(conn, 200) =~ "Account connected with SLaM"
    end
  end

  describe "current_user is not assigned in the session" do
    test "index is redirected and conn halted", %{conn: conn} do
      conn = get conn, account_path(conn, :index)
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "update is redirected and conn halted", %{conn: conn} do
      conn = put conn, account_path(conn, :update), user: @valid_attrs
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "consent is redirected and conn halted", %{conn: conn} do
      conn = get conn, account_path(conn, :consent)
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "update_consent is redirected and conn halted", %{conn: conn} do
      conn = put conn, account_path(conn, :update_consent), user: %{data_access: true}
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "edit_security is redirected and conn halted", %{conn: conn} do
      conn = get conn, account_path(conn, :edit_security)
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "update_security is redirected and conn halted", %{conn: conn} do
      conn = put conn, account_path(conn, :update_security)
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "edit_password is redirected and conn halted", %{conn: conn} do
      conn = get conn, account_path(conn, :edit_password)
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "update_password is redirected and conn halted", %{conn: conn} do
       conn = put conn, account_path(conn, :update_password)
       assert html_response(conn, 302)
       assert conn.halted
    end

    test "slam is redirected and conn halted", %{conn: conn} do
      conn = get conn, account_path(conn, :slam)
      assert html_response(conn, 302)
      assert conn.halted
    end
  end
end
