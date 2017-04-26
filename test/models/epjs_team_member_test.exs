defmodule Healthlocker.EPJSTeamMemberTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.EPJSTeamMember

  @valid_attrs %{
    Patient_ID: 1,
    Staff_ID: 1
  }

  @invalid_attrs %{
    Patient_ID: "vnbm",
    Staff_ID: "mfhjgmbnbm"
  }

  test "changeset with valid attributes" do
    changeset = EPJSTeamMember.changeset(%EPJSTeamMember{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = EPJSTeamMember.changeset(%EPJSTeamMember{}, @invalid_attrs)
    refute changeset.valid?
  end
end
