defmodule Healthlocker.PasswordController do
  use Healthlocker.Web, :controller

  alias Healthlocker.User

  def new(conn, _params) do
    changeset = User.email_changeset(%User{})
    render conn, "new.html", changeset: changeset, action: password_path(conn, :create)
  end

  def create(conn, %{"user" => pw_params}) do
    user = case pw_params["email"] do
      nil ->
        nil
      email ->
        User
        |> Repo.get_by(email: pw_params["email"])
    end
    
    case user do
      nil ->
        conn
        |> put_flash(:error, "Could not send reset email. Please try again later")
        |> redirect(to: login_path(conn, :index))
      user ->
        # generate token here + sent at and save
        conn
        |> put_flash(:info, "Password reset sent")
        |> redirect(to: login_path(conn, :index))
    end
  end
end
