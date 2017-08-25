defmodule Healthlocker.Post do
  use Healthlocker.Web, :model

  schema "posts" do
    field :content, :string
    belongs_to :user, Healthlocker.User
    many_to_many :likes, Healthlocker.User, join_through: "posts_likes", on_replace: :delete

    timestamps()
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, [:content])
    |> validate_required([:content])
  end

  def find_tags(query, params) do
    from p in query,
    where: ilike(p.content, ^"%##{params["tag"]}%"),
    preload: [:likes]
  end

  def find_tips(query) do
    from p in query,
    where: ilike(p.content, "%#tip%"),
    preload: [:likes]
  end

  def find_stories(query) do
    from p in query,
    where: ilike(p.content, "%#story%"),
    preload: [:likes]
  end

  def get_coping_strategies(query, user_id) do
    from p in query,
    where: like(p.content, "%#CopingStrategy") and p.user_id == ^user_id,
    order_by: [desc: p.updated_at]
  end

  def get_coping_strategy_by_user(query, id, user_id) do
    from p in query,
    where: p.id == ^id and p.user_id == ^user_id
  end
end
