defmodule Healthlocker.Oxleas.CaseloadView do
  use Healthlocker.Web, :view

  def room_for(user) do
    [room| _] = user.rooms
    room
  end
end
