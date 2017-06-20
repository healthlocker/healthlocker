defmodule Healthlocker.EPJSUser do
  use Healthlocker.Web, :model

  @primary_key {:Patient_ID, :integer, autogenerate: false}
  schema "mhlPatIndex" do
    field :Surname, :string
    field :Forename, :string
    field :Title, :string
    field :Patient_Name, :string
    field :Trust_ID, :string
    field :NHS_Number, :string
    field :DOB, :utc_datetime
    field :Spell_Number, :integer
    field :Spell_Start_Date, :utc_datetime
    field :Spell_End_Date, :utc_datetime
  end

  def changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [:Patient_ID, :Surname, :Forename, :NHS_Number, :DOB])
    |> validate_required([:Surname, :Forename, :NHS_Number, :DOB])
  end
end
