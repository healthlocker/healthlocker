defmodule Healthlocker.CopingStrategyView do
  use Healthlocker.Web, :view
  import Healthlocker.PostView, only: [markdown: 1]

  def format_output(text) do
    text
    |> String.trim_trailing(" #CopingStrategy")
    |> markdown()
  end
end
