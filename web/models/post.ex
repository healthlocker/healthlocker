defmodule Healthlocker.Post do
  use Healthlocker.Web, :model

  schema "posts" do
    field :content, :string
    belongs_to :user, Healthlocker.User

    timestamps()
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, [:content])
    |> validate_required([:content])
  end

  def find_single_story(query) do
    from p in query,
      limit: 1,
      where: ilike(p.content, "%#story%")
  end

  def find_single_tip(query) do
    from p in query,
      limit: 1,
      where: ilike(p.content, "%#tip%")
  end

  def find_tags(query, params) do
    from p in query,
    where: ilike(p.content, ^"%##{params["tag"]}%")
  end

  def find_tips(query) do
    from p in query,
    where: ilike(p.content, "%#tip%")
  end

  def find_stories(query) do
    from p in query,
    where: ilike(p.content, "%#story%")
  end

  def get_coping_strategies(query) do
    from p in query,
    where: like(p.content, "%#CopingStrategy")
  end
end
