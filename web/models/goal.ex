defmodule Healthlocker.Goal do
  use Healthlocker.Web, :model

  schema "goals" do
    field :content, :string
    field :completed, :boolean
    field :notes, :string
    field :important, :boolean
    has_many :steps, Healthlocker.Step
    belongs_to :user, Healthlocker.User

    timestamps()
  end

  def changeset(struct, params \\ :invalid) do
    struct
    |> mark_important_changeset(params)
    |> cast(params, [:content])
    |> validate_required(:content)
  end

  def mark_important_changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [:important])
  end

  def get_goals(query, user_id) do
    from g in query,
    where: like(g.content, "%#Goal") and g.user_id == ^user_id
  end

  def get_important_goals(query, user_id) do
    from g in query,
    where: like(g.content, "%#Goal") and g.user_id == ^user_id and g.important,
    order_by: [desc: g.updated_at]
  end

  def get_unimportant_goals(query, user_id) do
    from g in query,
    where: like(g.content, "%#Goal") and g.user_id == ^user_id and not g.important,
    order_by: [desc: g.updated_at]
  end

  def get_goal_by_user(query, id, user_id) do
    from g in query,
    where: g.id == ^id and g.user_id == ^user_id
  end
end
