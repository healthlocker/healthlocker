defmodule Healthlocker.Address do
  use Healthlocker.Web, :model

  schema "addresses" do
    field :flat_number, :integer
    field :building_name, :string
    field :street_name, :string
    field :post_code, :string
    field :city, :string
    belongs_to :slam_user, Healthlocker.SlamUser

    timestamps()
  end

  def changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [:flat_number, :building_name, :street_name, :post_code, :city])
  end
end
