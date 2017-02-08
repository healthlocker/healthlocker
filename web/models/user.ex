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
  def changeset(struct, params \\ :empty) do
    struct
    |> cast(params, [:email, :name, :answer, :selected_question, :data_access, :role])
    |> validate_required([:email, :selected_question, :answer, :data_access, :role])
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, [:password, :answer])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  def put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass, answer: ans}} ->
        put_change(changeset, :password_hash, Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
