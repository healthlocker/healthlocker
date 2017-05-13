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
end
