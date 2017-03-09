defmodule Healthlocker.Goal do
  use Healthlocker.Web, :model

  schema "goals" do
    field :content, :string
    field :completed, :boolean
    field :notes, :string

    timestamps()
  end

  def changeset(struct, params \\ :invalid) do
    struct
    | cast(params, [:content])
    |> validate_required(:content)
  end

end
