defmodule Healthlocker.SymptomTracker do
  use Healthlocker.Web, :model

  schema "symptom_trackers" do
    field :affected_scale, :string, null: false
    field :notes, :string
    belongs_to :symptom, Healthlocker.Symptom

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:affected_scale, :notes])
    |> validate_required([:affected_scale])
  end
end
