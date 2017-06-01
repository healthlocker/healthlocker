defmodule Healthlocker.PostView do
  use Healthlocker.Web, :view
  use Timex

  def markdown(body) do
    body
    |> Earmark.as_html!
    |> raw
  end

  def heading(post) do
    if Regex.match?(header_regex(), post.content)  do
      Regex.run(header_regex(), post.content) |> List.last |> String.trim
    end
  end

  def paragraphs(post) do
    String.split(body(post), paragraph_regex(), trim: true)
    |> Enum.map(fn x -> String.trim(x) end)
  end

  def body(post) do
    [head | _] = String.split(post.content, header_regex(), trim: true)
    head
  end

  def time_ago_in_words(date) do
    Timex.from_now(date)
  end

  defp header_regex do
    ~r/(#+)(.*)/
  end

  defp paragraph_regex do
    ~r/\n([^\n]+)\n/
  end

  def return_string(string) do
    case get_header_and_paragraph(string) do
      nil ->
        string
      list ->
        Enum.join(list, "\n\n")
    end
  end

  def get_header_and_paragraph(string) do
    cond do
      String.contains?(string, "\r\r") ->
        get_line_break(string, "\r\r")
      String.contains?(string, "\r\n\r\n") ->
        get_line_break(string, "\r\n\r\n")
      String.contains?(string, "\n\n") ->
        get_line_break(string, "\n\n")
      true ->
        nil
    end
  end

  def get_line_break(string, regex) do
    String.split(string, regex)
    |> Enum.chunk(3)
    |> List.first
  end
end
