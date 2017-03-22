defmodule Healthlocker.Message do
  use Healthlocker.Web, :model

  schema "messages" do
    field :body, :string
    field :name, :string
    belongs_to :user, Healthlocker.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body])
    |> validate_required([:body])
  end
end
