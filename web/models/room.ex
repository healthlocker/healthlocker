defmodule Healthlocker.Room do
  use Healthlocker.Web, :model

  schema "rooms" do
    field :name, :string
    many_to_many :users, Healthlocker.User, join_through: "user_rooms", on_delete: :delete_all
    has_many :messages, Healthlocker.Message

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
