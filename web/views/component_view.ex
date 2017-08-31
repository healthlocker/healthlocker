defmodule Healthlocker.ComponentView do
  use Healthlocker.Web, :view
  use Timex

  def get_options(option_type) do
    # load security questions from file
    options = case Application.get_env(:healthlocker, :environment) do
      :prod ->
        Application.app_dir(:healthlocker, "priv")
        |> Path.join("/static/#{option_type}.txt")
        |> File.read!
      _ ->
        "web/static/assets/#{option_type}.txt" |> File.read!
      end
    # split on line breaks to separate the options:
    String.split(options, "\n") |> List.delete("")
  end

  # changes datetime to DD/MM/YYYY format
  def datetime_formatter(datetime) do
    Timex.format!(datetime, "%d/%m/%Y", :strftime)
  end

  # gives the date in the format DD/MM/YYYY
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

  @tips ["#Connect", "#KeepLearning", "#GiveToOthers", "#BeActive", "#TakeNotice"]

  def markdown(body) do
    body
    |> Earmark.as_html!
    |> wrap_tags
    |> raw
  end

  defp handle_url(tip) do
    tip = String.trim_leading(tip, "#")
    cond do
      String.downcase(tip) == "tip" -> ""
      true -> "?tag=#{tip}"
    end
  end

  defp add_link(tip, html) do
    html
    |> String.split(tip)
    |> Enum.join("<a href=\"/tips#{handle_url(tip)}\" class=\"link hl-aqua underline\">#{tip}</a>")
  end

  defp add_links(html) do
    ["#Tip" | @tips] |> Enum.reduce(html, &add_link/2)
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
    if Keyword.has_key?(changeset.errors, field) && changeset.action do
      "hl-input-error hl-bg-error"
    else
      ""
    end
  end

  def full_name(user) do
    cond do
      Map.has_key?(user, "first_name") or Map.has_key?(user, "last_name") ->
        to_string(user["first_name"]) <> " " <> to_string(user["last_name"])
      Map.has_key?(user, :first_name) or Map.has_key?(user, :last_name) ->
        to_string(user.first_name) <> " " <> to_string(user.last_name)
      true ->
        to_string(user."Forename") <> " " <> to_string(user."Surname")
    end
  end

  def epjs_full_name(user) do
    user."Staff_Name"
  end

  def epjs_job_title(user) do
    user."Job_Title"
  end

end
