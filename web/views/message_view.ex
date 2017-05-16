defmodule Healthlocker.MessageView do
  use Healthlocker.Web, :view

  def dom_id(message) do
    "message-" <> Integer.to_string(message.id)
  end

  def user_name(message) do
    message.user.first_name <> " " <> message.user.last_name
  end

  def sent_at(message) do
    Timex.from_now(message.inserted_at)
  end

  def sent_by_user(message) do
    message.user.role != "clinician"
  end

  def clinician?(user) do
    user.role == "clinician"
  end

  @base_classes "w-80 br2 mb2 pa1 pa3-ns"
  @sender_classes "hl-bg-yellow fr"
  @receiver_classes "hl-bg-aqua fl"

  def classes(_message, nil) do
    @base_classes
  end

  def classes(message, current_user_id) do
    communicator = if message.user.id == current_user_id do
      @sender_classes
    else
      @receiver_classes
    end

    @base_classes <> " " <> communicator
  end
end
