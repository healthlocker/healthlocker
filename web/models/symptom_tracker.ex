defmodule Healthlocker.SymptomTracker do
  use Healthlocker.Web, :model
  alias Healthlocker.{SymptomTracker, SleepTracker}

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

  def symptom_tracking_data_query(query, symptom, date) do
    from st in SymptomTracker,
    where: st.symptom_id == ^symptom.id and
    st.inserted_at <= ^date and
    st.inserted_at > ^SleepTracker.last_week(date),
    order_by: [desc: st.inserted_at],
    preload: [:symptom]
  end
end
