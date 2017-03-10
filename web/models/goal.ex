defmodule Healthlocker.Goal do
  use Healthlocker.Web, :model

  schema "goals" do
    field :content, :string
    field :completed, :boolean
    field :notes, :string
    field :important, :boolean
    belongs_to :user, Healthlocker.User

    timestamps()
  end

  def changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [:content])
    |> validate_required(:content)
  end

  def mark_important_changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [:important])
  end

  def get_goals(query, user_id) do
    from p in query,
    where: like(p.content, "%#Goal") and p.user_id == ^user_id
  end

  def get_goal_by_user(query, id, user_id) do
    from p in query,
    where: p.id == ^id and p.user_id == ^user_id
  end
end
