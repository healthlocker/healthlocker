defmodule Healthlocker.LoginController do
  use Healthlocker.Web, :controller
  alias Healthlocker.Plugs.Auth

  def index(conn, _) do
    conn
    |> render("index.html")
  end

  def create(conn, %{"login" => %{"email" => email, "password" => pass}}) do
    case Auth.email_and_pass_login(conn, String.downcase(email), pass, repo: Repo) do
      {:ok, conn} ->
        user = conn.assigns.current_user
        case user do
          %{data_access: nil} ->
            conn
            |> Auth.logout()
            |> put_flash(:error, "You must accept terms of service and privacy statement")
            |> redirect(to: user_user_path(conn, :signup3, user))
          %{role: "admin"} ->
            conn
            |> put_flash(:info, "Welcome to Healthlocker Admin")
            |> redirect(to: post_path(conn, :new))
          _ ->
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
