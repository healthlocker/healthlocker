defmodule Healthlocker.Slam.CarerConnection do
  use Ecto.Schema
  import Ecto.Changeset
  alias Healthlocker.{QueryEpjs}

  embedded_schema do
    field :forename
    field :surname
    field :date_of_birth
    field :nhs_number # should this be a string or int? Any other particulars?
    field :epjs_patient_id, :integer
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [:forename, :surname, :date_of_birth, :nhs_number])
    |> cast_datetime(:date_of_birth)
    |> validate_required([:forename, :surname, :date_of_birth, :nhs_number])
    |> validate_slam()
  end

  defp validate_slam(changeset, options \\ []) do
    epjs_user = find_epjs_user(changeset)

    changeset = validate_change(changeset, :nhs_number, fn _, _ ->
      if epjs_user, do: [], else: [{:nhs_number, options[:message] || "details do not match"}]
    end)

    if epjs_user, do: put_change(changeset, :epjs_patient_id, epjs_user."Patient_ID"), else: changeset
  end

  def find_epjs_user(%{changes: changes}) when changes == %{} do
    nil
  end

  def find_epjs_user(changeset) do
    QueryEpjs.query_epjs("http://localhost:4001/epjs-user/carer-connection/find_epjs_user?changeset=", changeset)
  end

  defp cast_datetime(changeset, field) do
    if value = get_change(changeset, field) do
      datetime = value |> Timex.parse!("%d/%m/%Y", :strftime) |> DateTime.from_naive!("Etc/UTC")
      put_change(changeset, field, datetime)
    else
      changeset
    end
  end
end
