defmodule Healthlocker.TipView do
  use Healthlocker.Web, :view

  def markdown(body) do
    body
    |> Earmark.as_html!
    |> raw
  end

  def tip_tag(content) do
    cond do
      String.contains?(String.downcase(content), "#connect") -> "Connect"
      String.contains?(String.downcase(content), "#keeplearning") -> "KeepLearning"
      String.contains?(String.downcase(content), "#givetoothers") -> "GiveToOthers"
      String.contains?(String.downcase(content), "#beactive") -> "BeActive"
      String.contains?(String.downcase(content), "#takenotice") -> "TakeNotice"
      true -> "no tag found"
    end
  end
end
