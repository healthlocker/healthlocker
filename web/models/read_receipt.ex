defmodule Healthlocker.ReadReceipt do
  use Healthlocker.Web, :model

  schema "read_receipts" do
    belongs_to :message, Healthlocker.Message
    belongs_to :user, Healthlocker.User

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:message_id, :user_id])
    |> validate_required([:message_id, :user_id])
    |> assoc_constraint(:message)
    |> assoc_constraint(:user)
  end
end
