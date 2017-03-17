defmodule Healthlocker.MessageView do
  use Healthlocker.Web, :view

  def render("message.json", %{message: msg}) do
    %{
      id: msg.id,
      body: msg.body,
      name: msg.name
    }
  end
end
