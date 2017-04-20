defmodule Healthlocker.EPJSUser do
  use Healthlocker.Web, :model

  schema "epjs_users" do
    field :patient_id, :integer
    field :surname, :string
    field :forename, :string
    field :title, :string
    field :patient_name, :string
    field :trust_id, :string
    field :nhs_number, :string
    field :dob, :utc_datetime
    field :spell_number, :integer
    field :spell_start_date, :utc_datetime
    field :spell_end_date, :utc_datetime
  end

  def changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [:patient_id, :surname, :forename, :nhs_number, :dob])
    |> validate_required([:surname, :forename, :nhs_number, :dob])
  end
end
