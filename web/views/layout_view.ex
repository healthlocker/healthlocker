defmodule Healthlocker.LayoutView do
  use Healthlocker.Web, :view

  def segment_snippet do
    if segment_api_key, do: render(Healthlocker.LayoutView, "_segment.html")
  end

  defp segment_api_key do
    System.get_env("SEGMENT_API_KEY")
  end
end
