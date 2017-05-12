defmodule Healthlocker.PasswordController do
  use Healthlocker.Web, :controller

  alias Healthlocker.User

  def new(conn, _params) do
    changeset = User.email_changeset(%User{})
    render conn, "new.html", changeset: changeset, action: password_path(conn, :create)
  end

  def create(conn, %{"user" => pw_params}) do
    email = pw_params["email"]
    user = case email do
      nil ->
        nil
      email ->
        User
        |> Repo.get_by(email: email)
    end

    case user do
      nil ->
        conn
        |> put_flash(:error, "Could not send reset email. Please try again later")
        |> redirect(to: login_path(conn, :index))
      user ->
        reset_password_token(user)
        # send password token to pw_params["email"]
        Healthlocker.Email.send_reset_email(email, user.reset_password_token)
        |> Healthlocker.Mailer.deliver_now()

        conn
        |> put_flash(:info, "Password reset sent")
        |> redirect(to: login_path(conn, :index))
    end
  end

  defp reset_password_token(user) do
    token = random_string(48)
    sent_at = DateTime.utc_now

    user
    |> User.password_token_changeset(%{reset_password_token: token, reset_token_sent_at: sent_at})
    |> Repo.update!
  end

  defp random_string(length) do
    length
    |> :crypto.strong_rand_bytes
    |> Base.url_encode64
    |> binary_part(0, length)
  end
end
