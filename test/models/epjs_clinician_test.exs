defmodule Healthlocker.EPJSClinicianTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.EPJSClinician

  @valid_attrs %{
    GP_Code: "sbdkbakyb3unki3",
    First_Name: "Jack",
    Last_Name: "Em"
  }

  @invalid_attrs %{
    GP_code: 12345678,
    First_Name: 1,
    Last_Name: 2
  }

  test "changeset with valid attributes" do
    changeset = EPJSClinician.changeset(%EPJSClinician{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = EPJSClinician.changeset(%EPJSClinician{}, @invalid_attrs)
    refute changeset.valid?
  end
end
