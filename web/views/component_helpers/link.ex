defmodule Healthlocker.ComponentHelpers.Link do
  use Phoenix.HTML

  @base_classes "link hl-aqua underline-hover"

  def link_to(text, opts \\ []) do
    link(text, [class: @base_classes] ++ opts)
  end
end
