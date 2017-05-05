defmodule Healthlocker.Goal do
  use Healthlocker.Web, :model

  schema "goals" do
    field :content, :string
    field :completed, :boolean
    field :notes, :string
    field :important, :boolean
    has_many :steps, Healthlocker.Step, on_delete: :delete_all,
                                        on_replace: :delete
    belongs_to :user, Healthlocker.User

    timestamps()
  end

  def changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [:content, :important, :completed, :notes])
    |> cast_assoc(:steps)
    |> validate_required(:content)
  end

  def get_goals(query, user_id) do
    from g in query,
    where: like(g.content, "%#Goal") and g.user_id == ^user_id,
    preload: [:steps]
  end

  def get_important_goals(query, user_id) do
    from g in query,
    where: like(g.content, "%#Goal") and g.user_id == ^user_id and g.important,
    order_by: [desc: g.updated_at],
    preload: [:steps]
  end

  def get_unimportant_goals(query, user_id) do
    from g in query,
    where: like(g.content, "%#Goal") and g.user_id == ^user_id and not g.important,
    order_by: [desc: g.updated_at],
    preload: [:steps]
  end

  def get_goal_by_user(query, id, user_id) do
    steps_query = from s in Healthlocker.Step, order_by: s.inserted_at
    from g in query,
    where: g.id == ^id and g.user_id == ^user_id,
    preload: [steps: ^steps_query]
  end
end
