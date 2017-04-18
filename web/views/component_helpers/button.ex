defmodule Healthlocker.ComponentHelpers.Button do

  @moduledoc """
  Convenience methods for generating styled `<a>`, `<button>` and `<input>`
  elements in HTML. This enforces our styleguide, explicity primary, secondary
  and inactive styles.
  """

  use Phoenix.HTML

  @base_classes "f5 link dib ph3 pv2 br-pill hl-dark-blue pointer hl-shadow-hover"
  def primary_classes, do: @base_classes <> " " <> "hl-bg-yellow"
  def secondary_classes, do: @base_classes <> " " <> "ba bw1 b--hl-yellow bg-white"
  def inactive_classes, do: @base_classes <> " " <> "hl-bg-grey"

  def link_primary(text, opts) do
    link(text, [class: primary_classes()] ++ opts)
  end

  def link_secondary(text, opts) do
    link(text, [class: secondary_classes()] ++ opts)
  end

  def link_inactive(text, opts) do
    link(text, [class: inactive_classes] ++ opts)
  end

  def submit_primary(value, opts \\ []) do
    submit(value, [class: primary_classes] ++ opts)
  end
end
