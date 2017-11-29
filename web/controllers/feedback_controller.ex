defmodule Healthlocker.FeedbackController do
  use Healthlocker.Web, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  def create(conn, %{"feedback" => %{"subject" => subject, "content" => content, "email" => email}}) do
    Healthlocker.Email.send_feedback(subject, content, email)
    |> Healthlocker.Mailer.deliver_now()

    conn
    |> put_flash(:info, "Feedback Sent")
    |> redirect(to: feedback_path(conn, :index))
  end
end
