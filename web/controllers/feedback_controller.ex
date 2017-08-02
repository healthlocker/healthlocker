defmodule Healthlocker.FeedbackController do
  use Healthlocker.Web, :controller

  def index(conn, _params) do
    conn
    |> Healthlocker.SetView.set_view("CaseloadView")
    |> render("index.html")
  end

  def create(conn, %{"feedback" => %{"subject" => subject, "content" => content}}) do
    Healthlocker.Email.send_feedback(subject, content)
    |> Healthlocker.Mailer.deliver_now()

    conn
    |> put_flash(:info, "Feedback Sent")
    |> redirect(to: feedback_path(conn, :index))
  end
end
