defmodule Healthlocker.MessageControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.User

  describe "message routes with current user" do
    setup do
      %User{
        id: 123456,
        name: "MyName",
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password")
      } |> Repo.insert

      {:ok, conn: build_conn |> assign(:current_user, Repo.get(User, 123456))}
    end

    test "GET /messages", %{conn: conn} do
      conn = get conn, message_path(conn, :index)
      assert html_response(conn, 200) =~ "Enter a message"
    end
  end

  describe "message routes without current user" do
    test "GET /messages", %{conn: conn} do
      conn = get conn, message_path(conn, :index)
      assert html_response(conn, 302)
      assert conn.halted
    end
  end
end
