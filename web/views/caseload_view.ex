defmodule Healthlocker.CaseloadView do
  use Healthlocker.Web, :view

  def room_for(carer) do
    [room| _] = carer.rooms
    room
  end
end
