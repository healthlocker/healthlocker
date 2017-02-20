defmodule Healthlocker.ToolkitControllerTest do
  use Healthlocker.ConnCase
  alias Healthlocker.User

  setup do
    %User{
      id: 123456,
      name: "MyName",
      email: "abc@gmail.com",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password")
    } |> Repo.insert

    {:ok, user: Repo.get(User, 123456) }
  end

  test "renders index.html on /toolkit", %{conn: conn, user: user} do
    conn = build_conn()
        |> assign(:current_user, user)
        |> get(toolkit_path(conn, :index))
    assert html_response(conn, 200) =~ "Toolkit"
  end
end
