defmodule Healthlocker.MessageView do
  use Healthlocker.Web, :view



  def user_name(message) do
    message.user.name
  end

  def sent_at(message) do
    Timex.from_now(message.inserted_at)
  end

  @base_classes "w-80 br2 mb2 pa1 pa3-ns"
  @sender_classes "hl-bg-yellow fr"
  @receiver_classes "hl-bg-aqua fl"

  def classes(message, current_user) do
    if message.user.id == current_user.id do
      @base_classes <> " " <> @sender_classes
    else
      @base_classes <> " " <> @receiver_classes
    end
  end
end
