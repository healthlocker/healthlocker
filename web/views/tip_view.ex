defmodule Healthlocker.TipView do
  use Healthlocker.Web, :view

  @tips ["Connect", "KeepLearning", "GiveToOthers", "BeActive", "TakeNotice"]

  def markdown(body) do
    body
    |> Earmark.as_html!
    |> wrap_tags
    |> raw
  end

  defp handle_url(tip) do
    cond do
      String.downcase(tip) == "#tip" -> ""
      true -> "?tag=#{tip}"
    end
  end

  defp add_link(tip, html) do
    html
    |> String.split(tip)
    |> Enum.join("<a href=\"/tips#{handle_url(tip)}\">#{tip}</a>")
  end

  defp add_links(html) do
    ["Tip" | @tips] |> Enum.reduce(html, &add_link/2)
  end

  defp add_links_first_elem([empty_str | [head_html | tail_html]]) do
    [empty_str | [add_links(head_html) | tail_html]]
  end

  defp wrap_tags(content) do
    content
    |> String.split("\n")
    |> Enum.reverse
    |> add_links_first_elem
    |> Enum.reverse
    |> Enum.join("\n")
  end
end
