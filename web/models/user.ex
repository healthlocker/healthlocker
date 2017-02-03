defmodule Healthlocker.User do
  use Healthlocker.Web, :model

  schema "user" do
    field :email, :string
    field :password, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password_hashed])
    |> validate_required([:email, :password_hashed])
  end
end
