defmodule Healthlocker.User do
  use Healthlocker.Web, :model

  schema "users" do
    field :name, :string
    field :dob, Ecto.Date
    field :email, :string
    field :password, :string
    field :pin, :string
    field :security_question, :string
    field :security_answer, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :dob, :email, :password, :pin, :security_question, :security_answer])
    |> validate_required([:name, :dob, :email, :password, :pin, :security_question, :security_answer])
  end
end
