defmodule Healthlocker.GoalTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.Goal

  @valid_attrs %{content: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Goal.changeset(%Goal{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Goal.changeset(%Goal{}, @invalid_attrs)
    refute changeset.valid?
  end
end
