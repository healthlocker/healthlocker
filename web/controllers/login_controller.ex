defmodule Healthlocker.LoginController do
  use Healthlocker.Web, :controller

  def index(conn, _) do
    render conn, "index.html"
  end

  def create(conn, %{"login" => %{"email" => email, "password" => pass}}) do
    case Healthlocker.Auth.email_and_pass_login(conn, email, pass, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome to Healthlocker!")
        |> redirect(to: post_path(conn, :new))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("index.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Healthlocker.Auth.logout()
    |> redirect(to: page_path(conn, :index))
  end
end
