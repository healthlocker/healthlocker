defmodule Healthlocker.Post do
  use Healthlocker.Web, :model

  schema "posts" do
    field :content, :string
    many_to_many :likes, Healthlocker.User, join_through: "posts_likes"

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
      where: ilike(p.content, "%#story%"),
      preload: [:likes]
  end

  def find_single_tip(query) do
    from p in query,
      limit: 1,
      where: ilike(p.content, "%#tip%"),
      preload: [:likes]
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
end
