defmodule Healthlocker.AccountControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.User
  alias Healthlocker.Post

  setup do
    %User{
      id: 123456,
      name: "MyName",
      email: "abc@gmail.com",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password")
    } |> Repo.insert

    {:ok, user: Repo.get(User, 123456) }
  end

  @valid_attrs %{name: "NewName"}
  @invalid_attrs %{
    name: "",
    email: "",
    phone_number: ""
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
end
