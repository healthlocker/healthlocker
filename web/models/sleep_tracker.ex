defmodule Healthlocker.SleepTracker do
  use Healthlocker.Web, :model

  schema "sleep_trackers" do
    field :hours_slept, :string, null: false
    field :wake_count, :string
    field :notes, :string
    field :for_date, :date
    belongs_to :user, Healthlocker.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:hours_slept, :wake_count, :notes, :for_date])
    |> validate_required([:hours_slept])
  end

  def get_sleep_data(query, user_id, date) do
    from st in query,
    where: st.user_id == ^user_id and st.for_date <= ^date and st.for_date > ^last_week(date),
    order_by: [desc: :for_date],
    preload: [:user]
  end

  def get_sleep_data_today(query, user_id) do
    today = Date.utc_today()
    from st in query,
    where: st.user_id == ^user_id and st.for_date == ^today,
    preload: [:user]
  end

  defp last_week(end_date) do
    Timex.shift(end_date, days: -6)
  end
end
