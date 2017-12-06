defmodule Healthlocker.CopingStrategyView do
  use Healthlocker.Web, :view
  import Healthlocker.PostView, only: [markdown: 1]

  def format_output(text, tag) do
    case text do
      nil ->
        text
      _ ->
        text
        |> String.trim_trailing(tag)
        |> markdown()
    end
  end
end
