defmodule Healthlocker.EPJSUserTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.EPJSUser

  {:ok, dob} = DateTime.from_naive(~N[1975-01-14 13:26:08.003], "Etc/UTC")
  {:ok, start} = DateTime.from_naive(~N[1997-01-14 13:26:08.003], "Etc/UTC")

  @valid_attrs %{
    patient_id: 202,
    surname: "Burns",
    forename: "Evan",
    title: "Mr.",
    patient_name: "Evan Burns",
    trust_id: "uG0lDAx0S8",
    nhs_number: "gLiyI9gsgoHjQc6pMcaT",
    dob: dob,
    spell_number: 3,
    spell_start_date: start,
    spell_end_date: nil
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
