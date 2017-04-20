defmodule Healthlocker.EPJS_User do
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
end
