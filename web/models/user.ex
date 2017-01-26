defmodule Healthlocker.User do
  use Healthlocker.Web, :model

  schema "users" do
    field :name, :string
    field :dob, Ecto.Date
    field :email, :string
    field :password, :string
    field :pin, :string
    field :securityquestion, :string
    field :securityanswer, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :dob, :email, :password, :pin, :securityquestion, :securityanswer])
    |> validate_required([:name, :dob, :email, :password, :pin, :securityquestion, :securityanswer])
  end
end
