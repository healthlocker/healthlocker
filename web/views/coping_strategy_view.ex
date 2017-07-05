defmodule Healthlocker.CopingStrategyView do
  use Healthlocker.Web, :view
  alias Earmark

  def markdown(body) do
    body
    |> Earmark.as_html!
    |> raw
  end
end
