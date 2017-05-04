defmodule Healthlocker.SlamController do
  use Healthlocker.Web, :controller
  alias Healthlocker.Slam.CarerConnection
  alias Healthlocker.{Carer, Repo, User}

  def new(conn, _param) do
    changeset = CarerConnection.changeset(%CarerConnection{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"carer_connection" => params}) do
    update_params =  Map.update!(params, "nhs_number", &(String.split(&1, " ")
                                                          |> List.to_string))
    changeset = CarerConnection.changeset(%CarerConnection{}, update_params)

    if changeset.valid? do
      slam_id = Ecto.Changeset.get_field(changeset, :epjs_patient_id)

      query = from u in User, where: u.slam_id == ^slam_id
      service_user = Repo.one(query)

      if service_user do
        case Repo.insert(%Carer{carer: conn.assigns.current_user, caring: service_user}) do
          {:ok, _carer} ->
            conn
            |> put_flash(:info, "Account connected with SLaM")
            |> redirect(to: account_path(conn, :index))
          {:error, changeset} ->
            conn
            |> put_flash(:error, "Something went wrong")
            |> render("new.html", changeset: changeset)
        end
      else
        conn
        |> put_flash(:error, "Something went wrong")
        |> render("new.html", changeset: changeset)
      end
    else
      conn
      |> put_flash(:error, "Your Healthlocker account could not be linked with your SLaM health record. Please check your details are correct and try again.")
      |> render("new.html", changeset: changeset)
    end
  end
end
