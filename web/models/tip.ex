defmodule Healthlocker.Tip do
  use Healthlocker.Web, :model

  schema "tips" do
    field :value, :string
    field :tag, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:value, :tag])
    |> validate_required([:value, :tag])
  end
end
