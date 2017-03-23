defmodule Healthlocker.SleepTrackerTest do
  use Healthlocker.ModelCase

  alias Healthlocker.SleepTracker

  @valid_attrs %{hours_slept: 42, notes: "some content", wake_count: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SleepTracker.changeset(%SleepTracker{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SleepTracker.changeset(%SleepTracker{}, @invalid_attrs)
    refute changeset.valid?
  end
end
