defmodule Healthlocker.Symptom do
  use Healthlocker.Web, :model

  schema "symptoms" do
    field :symptom, :string, null: false
    belongs_to :user, Healthlocker.User
    has_many :symptom_trackers, Healthlocker.SymptomTracker, on_replace: :delete

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:symptom])
    |> validate_required([:symptom])
  end
end
