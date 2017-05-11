defmodule Healthlocker.CareTeam.MessageView do
  use Healthlocker.Web, :view

  def render("message.json", %{message: message}) do
    %{
      id: message.id,
      body: message.body,
      inserted_at: message.inserted_at,
      user: %{
        name: message.user.first_name <> " " <> message.user.last_name
      }
    }
  end
end
