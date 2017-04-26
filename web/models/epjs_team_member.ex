defmodule Healthlocker.EPJSTeamMember do
  use Healthlocker.Web, :model

  schema "epjs_team_members" do
    field :Patient_ID, :integer
    field :Staff_ID, :integer
  end

  def changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [:Patient_ID, :Staff_ID])
  end

  def patient_ids(query, clinician_id) do
    from e in query,
    where: e."Staff_ID" == ^clinician_id,
    select: e."Patient_ID"
  end
end
