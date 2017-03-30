defmodule Healthlocker.SleepTrackerView do
  use Healthlocker.Web, :view

  def today do
    Date.utc_today()
  end
end
