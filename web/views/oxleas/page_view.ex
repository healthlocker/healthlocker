defmodule Healthlocker.Oxleas.PageView do
  use Healthlocker.Web, :view
  import Healthlocker.ComponentView, only: [markdown: 1]

  def find_redirect(conn) do
    last_page = last_page(conn)
    if last_page && String.contains?(last_page, "/slam/new") do
      "/slam/new"
    else
      "/account/slam"
    end
  end

  defp last_page(conn) do
    conn
    |> Plug.Conn.get_req_header("referer")
    |> List.first
  end
end
