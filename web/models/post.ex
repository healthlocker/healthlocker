defmodule Healthlocker.Post do
  use Healthlocker.Web, :model

  schema "posts" do
    field :content, :string

    timestamps()
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, [:content])
    |> validate_required([:content])
  end

  def featured_story(query) do
    from p in query,
      limit: 1,
      where: ilike(p.content, "%#story%")
  end

  def featured_tip(query) do
    from p in query,
      limit: 1,
      where: ilike(p.content, "%#tip%")
  end
end
