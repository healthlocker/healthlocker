defmodule Healthlocker.PasswordController do
  use Healthlocker.Web, :controller

  alias Healthlocker.User
  use Timex

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

  def edit(conn, %{"id" => token}) do
    user = User
          |> Repo.get_by(reset_password_token: token)
    case user do
      nil ->
        conn
        |> put_flash(:error, "Invalid reset token")
        |> redirect(to: password_path(conn, :new))
      user ->
        if expired?(user.reset_token_sent_at) do
          # could set reset fields to nil here
          conn
          |> put_flash(:error, "Password reset token expired")
          |> redirect(to: password_path(conn, :new))
        else
          changeset = User.password_changeset(%User{})
          conn
          |> render("edit.html", changeset: changeset, token: token)
        end
    end
  end

  def update(conn, %{"id" => token, "user" => pw_params}) do
    user = User
          |> Repo.get_by(reset_password_token: token)
    case user do
      nil ->
        conn
        |> put_flash(:error, "Invalid reset token")
        |> redirect(to: password_path(conn, :new))
      user ->
        if expired?(user.reset_token_sent_at) do
          conn
          |> put_flash(:error, "Password reset token expired")
          |> redirect(to: password_path(conn, :new))
        else
          changeset = User.update_password(user, pw_params)
          case Repo.update(changeset) do
            {:ok, _user} ->
              conn
              |> put_flash(:info, "Password reset successfully!")
              |> redirect(to: login_path(conn, :index))
            {:error, changeset} ->
              conn
              |> render("edit.html", changeset: changeset, token: token)
          end
        end
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

  defp expired?(datetime) do
    Timex.after?(Timex.now, Timex.shift(datetime, days: 1))
  end
end
