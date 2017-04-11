defmodule Healthlocker.ComponentHelpers.Button do
  use Phoenix.HTML

  def button_base, do: "f5 link dim dib mb4 ph3 pv2 br-pill hl-dark-blue pointer"
  def button_primary, do: button_base() <> " " <> "hl-bg-yellow"
  def button_secondary, do: button_base() <> " " <> "ba bw1 b--hl-yellow bg-white"
  def button_inactive, do: button_base() <> " " <> "hl-bg-grey"

  def link_primary(text, opts) do
    link(text, [class: button_primary()] ++ opts)
  end

  def link_secondary(text, opts) do
    link(text, [class: button_secondary()] ++ opts)
  end

  def link_inactive(text, opts) do
    link(text, [class: button_inactive()] ++ opts)
  end

  def submit_primary(value, opts \\ []) do
    submit(value, [class: button_primary()] ++ opts)
  end
end
