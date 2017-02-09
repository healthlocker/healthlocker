defmodule Healthlocker.User do
  use Healthlocker.Web, :model

  alias Comeonin.Bcrypt

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :name, :string
    field :security_question, :string
    field :security_answer, :string
    field :data_access, :boolean
    field :role, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [:email, :name])
    |> validate_format(:email, ~r/@/)
    |> validate_required([:email])
  end

  def security_question(struct, params \\ :invalid) do
    struct
    |> cast(params, [:security_question, :security_answer])
  end

  def changeset3(struct, params) do
    struct
    |> cast(params, [:data_access, :role])
  end

  def registration_changeset(model, params) do
    model
    |> security_question(params)
    |> cast(params, [:password])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  def put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
