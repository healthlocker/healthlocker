defmodule Healthlocker.LoginController do
  use Healthlocker.Web, :controller

  alias Healthlocker.User
  alias Healthlocker.Plugs.Auth

  def index(conn, _) do
    render conn, "index.html"
  end

  def create(conn, %{"login" => %{"email" => email, "password" => pass}}) do
    case Auth.email_and_pass_login(conn, String.downcase(email), pass, repo: Repo) do
      {:ok, conn} ->
        user = conn.assigns.current_user
        if user.data_access == nil do
          conn
          |> Auth.logout()
          |> put_flash(:error, "You must accept terms of service and privacy statement")
          |> redirect(to: user_user_path(conn, :signup3, user))
        else
          conn
          |> put_flash(:info, "Welcome to Healthlocker!")
          |> redirect(to: toolkit_path(conn, :index))
        end
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("index.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Auth.logout()
    |> redirect(to: page_path(conn, :index))
  end
end
