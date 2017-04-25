defmodule Healthlocker.SlamController do
  use Healthlocker.Web, :controller
  alias Healthlocker.Slam.CarerConnection

  def new(conn, _param) do
    changeset = CarerConnection.changeset(%CarerConnection{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"carer_connection" => params}) do
    changeset = CarerConnection.changeset(%CarerConnection{}, params)

    if changeset.valid? do
      conn
      |> put_flash(:info, "Account connected with SLaM")
      |> redirect(to: account_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Your Healthlocker account could not be linked with your SLaM health record. Please check your details are correct and try again.")
      |> render("new.html", changeset: changeset)
    end
  end
end
