defmodule Healthlocker.Slam.CarerConnection do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Healthlocker.{EPJSUser, ReadOnlyRepo}

  embedded_schema do
    field :first_name
    field :last_name
    field :date_of_birth
    field :nhs_number # should this be a string or int? Any other particulars?
  end

  def changeset(connection, params \\ %{}) do
    connection
    |> cast(params, [:first_name, :last_name, :date_of_birth, :nhs_number])
    |> cast_datetime(:date_of_birth)
    |> validate_required([:first_name, :last_name, :date_of_birth, :nhs_number])
    |> validate_slam()
  end

  defp validate_slam(changeset, options \\ []) do
    validate_change(changeset, :nhs_number, fn _, _ ->
      %{changes: changes} = changeset
      first_name = Map.get(changes, :first_name)
      last_name = Map.get(changes, :last_name)
      date_of_birth = Map.get(changes, :date_of_birth)
      nhs_number = Map.get(changes, :nhs_number)

      query = from e in EPJSUser,
        where: e."Forename" == ^first_name
          and e."Surname" == ^last_name
          and e."DOB" == type(^date_of_birth, :utc_datetime)
          and e."NHS_Number" == ^nhs_number

      valid? = Healthlocker.ReadOnlyRepo.one(query)

      EPJSUser |> ReadOnlyRepo.all
      if valid?, do: [], else: [{:nhs_number, options[:message] || "details do not match"}]
    end)
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
