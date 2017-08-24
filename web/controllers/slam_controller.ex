defmodule Healthlocker.SlamController do
  use Healthlocker.Web, :controller
  alias Healthlocker.Slam.CarerConnection
  alias Healthlocker.{Repo, User, Slam.ConnectCarer}

  def new(conn, _param) do
    changeset = CarerConnection.changeset(%CarerConnection{})
    conn
    |> Healthlocker.SetView.set_view("SlamView")
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"carer_connection" => params}) do
    update_params = if params["nhs_number"] do
      params
      |> Map.update!("nhs_number", &(String.split(&1, " ")
      |> List.to_string))
    else
      params
    end

    changeset = CarerConnection.changeset(%CarerConnection{}, update_params)

    if changeset.valid? do
      slam_id = Ecto.Changeset.get_field(changeset, :epjs_patient_id)

      query = from u in User, where: u.slam_id == ^slam_id
      service_user = Repo.one(query)
      service_user_id = if service_user do
        service_user.id
      else
        nil
      end

      multi = ConnectCarer.connect_carer_and_create_rooms(conn.assigns.current_user, update_params, service_user_id, slam_id)
      case Repo.transaction(multi) do
        {:ok, _user} ->
          conn
          |> put_flash(:info, "Account connected!")
          |> redirect(to: account_path(conn, :index))
        {:error, _type, changeset, _} ->
          conn
          |> put_flash(:error, "Something went wrong")
          |> Healthlocker.SetView.set_view("SlamView")
          |> render("new.html", changeset: changeset)
      end
    else
      conn
      |> put_flash(:error, "Your Healthlocker account could not be linked with your health record. Please check your details are correct and try again.")
      |> Healthlocker.SetView.set_view("SlamView")
      |> render("new.html", changeset: changeset)
    end
  end
end
