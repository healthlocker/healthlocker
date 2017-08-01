defmodule Healthlocker.Plugs.AppNameTest do
  use Healthlocker.ConnCase

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(Healthlocker.Router, :browser)
      |> get("/")

    {:ok, conn: conn}
  end

  test "app_name defaults to healthlocker" do
    conn = conn |> app_name
    assert conn.assigns.app_name == "healthlocker"
  end

  defp app_name(conn) do
    conn
    |> Healthlocker.Plugs.AppName.call(%{})
  end
end
