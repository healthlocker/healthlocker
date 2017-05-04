defmodule Healthlocker.Caseload.MessageController do
  alias Healthlocker.{User}
  use Healthlocker.Web, :controller

  def show(conn, %{"id" => carer_id, "caseload_id" => _service_user_id}) do
    carer = Repo.get!(User, carer_id) |> Repo.preload(:rooms)
    [room|_] = carer.rooms

    conn
    |> assign(:room, room)
    |> render("show.html")
  end
end
