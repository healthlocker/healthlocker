defmodule Healthlocker.Analytics.EventNameBuilder do
  @moduledoc """
  Build event names based on the model and action performed.
  """

  def build(action, model), do: event_name(action, model)

  defp event_name(:create, %Healthlocker.Goal{}), do: "Goal Created"

# How are we going to distinguish the different post types? Can event_name take
# parameters?
  defp event_name(:create, %Healthlocker.Post{}), do: "Strategy Created"
end
