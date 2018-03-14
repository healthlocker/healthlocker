defmodule Healthlocker.ComponentHelpers.Header do
  use Phoenix.HTML

  @base_classes "tc hl-pink "

  def h2_header(text, opts \\ []) do
    case Keyword.fetch(opts, :class) do
      {:ok, classes} ->
        opts = Keyword.delete(opts, :class)
        content_tag(:h2, text, [class: @base_classes <> classes] ++ opts)
      _ ->
      content_tag(:h2, text, [class: @base_classes] ++ opts)
    end
  end
end
