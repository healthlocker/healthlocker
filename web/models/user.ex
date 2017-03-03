defmodule Healthlocker.User do
  use Healthlocker.Web, :model

  alias Comeonin.Bcrypt

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :name, :string
    field :phone_number, :string
    field :security_question, :string
    field :security_answer, :string
    field :data_access, :boolean
    field :role, :string
    field :slam_user, :boolean
    has_many :posts, Healthlocker.Post
    many_to_many :likes, Healthlocker.Post, join_through: "posts_likes", on_replace: :delete

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [:email, :name])
    |> validate_format(:email, ~r/@/)
    |> validate_required(:email)
  end

  def update_changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [:email, :name, :phone_number, :slam_user])
    |> validate_format(:email, ~r/@/)
    |> validate_required(:email)
  end

  def security_question(struct, params \\ :invalid) do
    struct
    |> cast(params, [:security_question, :security_answer])
    |> validate_required([:security_question, :security_answer])
  end

  def data_access(struct, params \\ :invalid) do
    struct
    |> cast(params, [:data_access])
    |> validate_acceptance(:terms_conditions)
    |> validate_acceptance(:privacy)
  end

  def update_data_access(struct, params \\ :invalid) do
    struct
    |> cast(params, [:data_access])
  end

  def registration_changeset(model, params) do
    model
    |> security_question(params)
    |> cast(params, [:password])
    |> validate_length(:password, min: 6, max: 100)
    |> validate_confirmation(:password, message: "Passwords do not match")
    |> put_pass_hash()
  end

  def password_changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [:password])
  end

  def update_password(struct, params \\ :invalid) do
    struct
    |> password_changeset(params)
    |> cast(params, [:password])
    |> validate_length(:password, min: 6, max: 100)
    |> validate_confirmation(:password, message: "New passwords do not match")
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
