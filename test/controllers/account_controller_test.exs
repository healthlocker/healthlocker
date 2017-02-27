defmodule Healthlocker.AccountControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.User
  alias Healthlocker.Post


  @valid_attrs %{name: "NewName"}
  @invalid_attrs %{
    name: "",
    email: "",
    phone_number: ""
  }

  describe "all account paths need current_user for access" do
    setup do
      %User{
        id: 123456,
        name: "MyName",
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password")
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
  end

end
