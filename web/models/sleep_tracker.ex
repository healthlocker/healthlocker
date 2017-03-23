defmodule Healthlocker.SleepTracker do
  use Healthlocker.Web, :model

  schema "sleeptrackers" do
    field :hours_slept, :integer
    field :wake_count, :integer
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
    |> validate_required([:hours_slept, :wake_count, :notes])
  end
end
