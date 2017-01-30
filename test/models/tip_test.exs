defmodule Healthlocker.TipTest do
  use Healthlocker.ModelCase

  alias Healthlocker.Tip

  @valid_attrs %{tag: "some content", value: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Tip.changeset(%Tip{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Tip.changeset(%Tip{}, @invalid_attrs)
    refute changeset.valid?
  end
end
