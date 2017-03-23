defmodule Healthlocker.SleepTracker do
  use Healthlocker.Web, :model

  schema "sleep_trackers" do
    field :hours_slept, :string
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
end
