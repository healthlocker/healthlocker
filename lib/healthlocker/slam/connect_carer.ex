defmodule Healthlocker.Slam.ConnectCarer do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Ecto.Multi
  alias Healthlocker.{User, Carer}

  def connect_carer_and_create_rooms(user, params, service_user) do
    Multi.new
    |> Multi.update(:user_name, User.name_changeset(user, %{first_name: params["first_name"], last_name: params["last_name"]}))
    |> Multi.insert(:carer, %Carer{carer: user, caring: service_user})
  end
end
