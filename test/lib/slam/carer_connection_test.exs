defmodule Healthlocker.Slam.CarerConnectionTest do
  use ExUnit.Case, async: true
  alias Healthlocker.Slam.CarerConnection

  @valid_attrs %{
    first_name: "Tony",
    last_name: "Daly",
    date_of_birth: DateTime.from_unix(1464096368),
    nhs_number: "943 476 5919"
  }
  @invalid_attrs %{
    first_name: "Tony",
    last_name: "Daly",
    date_of_birth: DateTime.from_unix(1464096368),
    nhs_number: "943 476 0000"
  }

  describe "changeset" do
    test "is valid when all details match" do
      changeset = CarerConnection.changeset(%CarerConnection{}, @valid_attrs)
      assert changeset.valid?
    end

    test "is invalid if any of the details do not match" do
      changeset = CarerConnection.changeset(%CarerConnection{}, @invalid_attrs)
      refute changeset.valid?
    end

    test "is invalid unless all the details are provided" do
      changeset = CarerConnection.changeset(%CarerConnection{}, %{})
      refute changeset.valid?
    end
  end
end
