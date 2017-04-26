defmodule Healthlocker.TipView do
  use Healthlocker.Web, :view
  import Healthlocker.ComponentView, only: [markdown: 1]

  @tips ["Connect", "KeepLearning", "GiveToOthers", "BeActive", "TakeNotice"]

  def image_url(tip) do
    category = @tips
            |> Enum.filter(fn type -> String.contains?(tip, type) end)
            |> List.first
    "/images/#{category}_Mini.svg"
  end
end
