defmodule Healthlocker.ComponentHelpers.Link do

  @moduledoc """
  Convenience methods for generating links in HTML. This enforces our
  styleguide, and delegates the creation to `Phoenix.HTML.Link.link/2`.
  """

  use Phoenix.HTML

  @base_classes "link hl-aqua underline"

  def link_to(text, opts \\ []) do
    link(text, [class: @base_classes] ++ opts)
  end

  def top_link do
    content_tag(:a, "", [class: "absolute top--2", name: "top"])
  end

  def back_to_top do
    content_tag(:a, "Back to top", [class: @base_classes, href: "#top"])
  end
end
