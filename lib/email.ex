defmodule Healthlocker.Email do
  use Bamboo.Phoenix, view: Healthlocker.FeedbackView

  def send_feedback(subject, message, email \\ "") do
    new_email()
    |> to([System.get_env("TO_EMAIL"), System.get_env("FROM_EMAIL")])
    |> from(System.get_env("FROM_EMAIL"))
    |> subject(subject)
    |> text_body("Message from: #{email}\n#{message}")
  end

  def send_reset_email(to_email, token, host) do
    new_email()
    |> to(to_email)
    |> from(System.get_env("FROM_EMAIL"))
    |> subject("Healthlocker Reset Password Instructions")
    |> text_body("Please visit https://#{host}/password/#{token}/edit to reset your password")
  end
end
