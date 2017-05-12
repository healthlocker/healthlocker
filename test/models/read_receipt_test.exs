defmodule Healthlocker.ReadReceiptTest do
  use Healthlocker.ModelCase

  alias Healthlocker.ReadReceipt

  @valid_attrs %{message_id: 1, user_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ReadReceipt.changeset(%ReadReceipt{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ReadReceipt.changeset(%ReadReceipt{}, @invalid_attrs)
    refute changeset.valid?
  end
end
