defmodule Healthlocker.LayoutView do
  use Healthlocker.Web, :view

  def segment_snippet do
    if segment_write_key, do: render(Healthlocker.LayoutView, "_segment.html")
  end

  def segment? do
    !!System.get_env("SEGMENT_WRITE_KEY")
  end

  defp segment_write_key do
    System.get_env("SEGMENT_WRITE_KEY")
  end
end
