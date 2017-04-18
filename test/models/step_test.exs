defmodule Healthlocker.StepTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.Step

  @valid_attrs %{
    details: "detail1",
    complete: false,
    goal_id: 1234
  }

  @invalid_attrs %{
    details: 1,
    complete: ""
  }

  test "changeset with valid attributes" do
    changeset = Step.changeset(%Step{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Step.changeset(%Step{}, @invalid_attrs)
    refute changeset.valid?
  end
end
