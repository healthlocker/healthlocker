defmodule Healthlocker.LoginController do
  use Healthlocker.Web, :controller

  alias Healthlocker.User

  def index(conn, _) do
    render conn, "index.html"
  end

  def create(conn, %{"login" => %{"email" => email, "password" => pass}}) do
    case Healthlocker.Auth.email_and_pass_login(conn, String.downcase(email), pass, repo: Repo) do
      {:ok, conn} ->
        user = Repo.get_by(User, email: email)
        if user.data_access == nil do
          conn
          |> Healthlocker.Auth.logout()
          |> put_flash(:error, "You must accept terms of service and privacy statement")
          |> redirect(to: "/users/#{user.id}/signup3", action: :signup3, user: user)
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
    |> Healthlocker.Auth.logout()
    |> redirect(to: page_path(conn, :index))
  end
end
