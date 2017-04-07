defmodule Healthlocker.Analytics.EventNameBuilder do
  @moduledoc """
  Build event names based on the model and action performed.
  """

  def build(action, model), do: event_name(action, model)

  defp event_name(:create, %Healthlocker.Goal{}), do: "Goal Created"

  defp event_name(:create, %Healthlocker.Post{}), do: "Strategy Created"
end
