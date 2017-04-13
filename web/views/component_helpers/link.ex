defmodule Healthlocker.ComponentHelpers.Link do
  @moduledoc """
  Convenience methods for generating links in HTML. This enforces our styleguide,
  and delegates the creation to `Phoenix.HTML.Link.link/2`
  """

  use Phoenix.HTML

  @base_classes "link hl-aqua underline-hover"

  def link_to(text, opts \\ []) do
    link(text, [class: @base_classes] ++ opts)
  end
end
