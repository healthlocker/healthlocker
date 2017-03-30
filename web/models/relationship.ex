defmodule Healthlocker.Relationship do
  use Healthlocker.Web, :model


  schema "relationships" do
    belongs_to :user, User
    belongs_to :contact, User

    timestamps()
  end

  def changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [:user, :contact])
    |> validate_required([:user, :contact])
  end
end
