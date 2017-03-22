defmodule Healthlocker.Analytics.PropertiesBuilder do
  @moduledoc """
  Used for building a properties map from a model.
  """
  def build(model), do: properties(model)

  defp properties(%Healthlocker.Goal{} = goal) do
    %{
      important: goal.important
    }
  end
end
