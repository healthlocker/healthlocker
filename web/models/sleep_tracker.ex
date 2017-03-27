defmodule Healthlocker.SleepTracker do
  use Healthlocker.Web, :model

  schema "sleep_trackers" do
    field :hours_slept, :string, null: false
    field :wake_count, :string
    field :notes, :string
    belongs_to :user, Healthlocker.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:hours_slept, :wake_count, :notes])
    |> validate_required([:hours_slept])
  end

  def get_sleep_data(query, user_id) do
    from st in query,
    where: st.user_id == ^user_id,
    preload: [:user]
  end
end
