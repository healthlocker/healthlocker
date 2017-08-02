defmodule Healthlocker.Oxleas.GoalView do
  use Healthlocker.Web, :view

  def markdown(body) do
    body
    |> Earmark.as_html!
    |> raw
  end
end
