defmodule Healthlocker.SlamUser do
  use Healthlocker.Web, :model

  schema "slam_users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :nhs_number, :string
    field :phone_number, :string
    field :date_of_birth, :string
    has_one :address, Healthlocker.Address
    has_one :user, Healthlocker.User

    timestamps()
  end

  def changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [:first_name, :last_name, :date_of_birth, :nhs_number])
    |> validate_required([:first_name, :last_name, :date_of_birth, :nhs_number])
  end
end
