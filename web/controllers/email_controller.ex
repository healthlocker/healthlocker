defmodule Healthlocker.EmailController do
  use Healthlocker.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, %{"email" => %{"subject" => email_to, "content" => email_from}}) do
    Healthlocker.Email.send_email(email_to, email_from)
    |> Healthlocker.Mailer.deliver_now()

    conn
    |> put_flash(:info, "Email Sent")
    |> redirect(to: email_path(conn, :index))
  end
end
