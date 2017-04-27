defmodule Healthlocker.EPJSUserTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.EPJSUser

  dob = DateTime.from_naive!(~N[1975-01-14 00:00:00.00], "Etc/UTC")
  start = DateTime.from_naive!(~N[1997-01-14 00:00:00.00], "Etc/UTC")

  @valid_attrs %{
    Patient_ID: 202,
    Surname: "Burns",
    Forename: "Evan",
    Title: "Mr.",
    Patient_Name: "Evan Burns",
    Trust_ID: "uG0lDAx0S8",
    NHS_Number: "gLiyI9gsgoHjQc6pMcaT",
    DOB: dob,
    Spell_Number: 3,
    Spell_Start_Date: start,
    Spell_End_Date: nil
  }

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = EPJSUser.changeset(%EPJSUser{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = EPJSUser.changeset(%EPJSUser{}, @invalid_attrs)
    refute changeset.valid?
  end
end
