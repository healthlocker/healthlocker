defmodule Healthlocker.Email do
  use Bamboo.Phoenix, view: Healthlocker.EmailView

  def send_email(subject, message) do
    new_email()
    |> to("my_email@gmail.com")
    |> from("my_email@gmail.com")
    |> subject(subject)
    |> text_body(message)
  end
end
