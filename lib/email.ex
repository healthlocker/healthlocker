defmodule Healthlocker.Feedback do
  use Bamboo.Phoenix, view: Healthlocker.FeedbackView

  def send_feedback(subject, message) do
    new_email()
    |> to("my_email@gmail.com")
    |> from("my_email@gmail.com")
    |> subject(subject)
    |> text_body(message)
  end
end
