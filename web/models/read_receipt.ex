defmodule Healthlocker.ReadReceipt do
  use Healthlocker.Web, :model

  schema "read_receipts" do
    belongs_to :message, Healthlocker.Message
    belongs_to :user, Healthlocker.User
    field :read, :boolean

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:message_id, :user_id, :read])
    |> validate_required([:message_id, :user_id, :read])
    |> assoc_constraint(:message)
    |> assoc_constraint(:user)
  end
end
