defmodule Healthlocker.SlamUser do
  use Healthlocker.Web, :model

  schema "slam_users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :nhs_number, :string
    field :phone_number, :string
    has_one :address, Healthlocker.Address

    timestamps()
  end
end
