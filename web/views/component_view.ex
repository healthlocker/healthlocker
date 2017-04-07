defmodule Healthlocker.ComponentView do
  use Healthlocker.Web, :view

  def get_options(option_type) do
    # load security questions from file
    questions = "web/static/assets/#{option_type}.txt" |> File.read!

    # split on line breaks to separate the questions:
    questions_list = String.split(questions, "\n")
                    |> List.delete("")

    # return the questions list
    questions_list
  end

  # gives the date in the format DD-MM-YYYY
  def pretty_date(date) do
    day = if date.day < 10 do
      "0" <> Integer.to_string(date.day)
    else
      Integer.to_string(date.day)
    end

    month = if date.month < 10 do
      "0" <> Integer.to_string(date.month)
    else
      Integer.to_string(date.month)
    end

    year = Integer.to_string(date.year)
    day <> "/" <> month <> "/" <> year
  end

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

  def highlight_errors(changeset, field) do
    if Keyword.has_key?(changeset.errors, field) do
      "hl-input-error"
    else
      ""
    end
  end
end
