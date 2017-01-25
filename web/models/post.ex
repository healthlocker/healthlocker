defmodule Healthlocker.Post do
  use Healthlocker.Web, :model

  schema "posts" do
    field :content, :string

    timestamps
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, ~w(content))
    |> validate_required([:content])
  end
end
