defmodule Healthlocker.Post do
  use Healthlocker.Web, :model

  schema "posts" do
    field :content, :string
    field :title, :string

    timestamps()
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, [:content, :title])
    |> validate_required([:content, :title])
  end
end
