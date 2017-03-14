defmodule Healthlocker.Feedback do
  use Bamboo.Phoenix, view: Healthlocker.FeedbackView

  def send_feedback(subject, message) do
    new_email()
    |> to(System.get_env("TO_EMAIL"))
    |> from(System.get_env("FROM_EMAIL"))
    |> subject(subject)
    |> text_body(message)
  end
end
