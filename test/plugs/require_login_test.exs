defmodule Healthlocker.Plugs.RequireLoginTest do
  use Healthlocker.ConnCase

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(Healthlocker.Router, :browser)
      |> get("/")

    {:ok, conn: conn}
  end

  test "user is redirected when current_user is not assigned", %{conn: conn} do
    conn = conn |> require_login
    assert redirected_to(conn) == "/login"
  end

  test "user passes through when current_user is assigned", %{conn: conn} do
    conn = conn |> authenticate |> require_login
    assert not_redirected?(conn)
  end

  defp require_login(conn) do
    conn |> Healthlocker.Plugs.RequireLogin.call(%{})
  end

  defp authenticate(conn) do
    conn |> assign(:current_user, %Healthlocker.User{})
  end

  defp not_redirected?(conn) do
    conn.status != 302
  end
end
