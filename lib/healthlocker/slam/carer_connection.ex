defmodule Healthlocker.Slam.CarerConnection do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Healthlocker.{EPJSUser, ReadOnlyRepo}

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

  defp find_epjs_user(%{changes: changes}) when changes == %{} do
    nil
  end

  defp find_epjs_user(%{changes: changes}) do
    %{forename: forename, surname: surname, date_of_birth: date_of_birth, nhs_number: nhs_number} = changes

    query = from e in EPJSUser,
      where: e."Forename" == ^forename
        and e."Surname" == ^surname
        and e."DOB" == ^date_of_birth
        and e."NHS_Number" == ^nhs_number

    ReadOnlyRepo.one(query)
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
