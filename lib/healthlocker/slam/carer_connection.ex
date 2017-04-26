defmodule Healthlocker.Slam.CarerConnection do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Healthlocker.{User, EPJSUser, ReadOnlyRepo}

  embedded_schema do
    field :first_name
    field :last_name
    field :date_of_birth, :date
    field :nhs_number # should this be a string or int? Any other particulars?
  end

  def changeset(connection, params \\ %{}) do
    connection
    |> cast(params, [:first_name, :last_name, :date_of_birth, :nhs_number])
    |> validate_required([:first_name, :last_name, :date_of_birth, :nhs_number])
    |> validate_slam([:first_name, :last_name, :date_of_birth, :nhs_number])
  end

  defp validate_slam(changeset, fields, options \\ []) do
    validate_change(changeset, :nhs_number, fn _, field ->
      %{changes: changes, errors: errors} = changeset
      first_name = Map.get(changes, :first_name)
      last_name = Map.get(changes, :last_name)
      date_of_birth = Map.get(changes, :date_of_birth)
      nhs_number = Map.get(changes, :nhs_number)

      query = from e in EPJSUser,
        where: e."Forename" == ^is_nil(first_name)
          and e."Surname" == ^is_nil(last_name)
          and e."DOB" == ^is_nil(date_of_birth)
          and e."NHS_Number" == ^is_nil(nhs_number)

      valid? = !!Healthlocker.ReadOnlyRepo.one(query)
      if valid?, do: [], else: [{field, options[:message] || "details do not match"}]
    end)
  end
end
