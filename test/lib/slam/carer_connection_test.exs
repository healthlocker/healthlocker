defmodule Healthlocker.Slam.CarerConnectionTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.Slam.CarerConnection
  alias Healthlocker.{EPJSUser, ReadOnlyRepo}

  @date_of_birth DateTime.from_naive!(~N[1989-01-01 00:00:00.00], "Etc/UTC")
  @valid_attrs %{
    first_name: "Kat",
    last_name: "Bow",
    date_of_birth: @date_of_birth,
    nhs_number: "uvhjbfnwqoekhfg8y9i"
  }
  @invalid_attrs %{
    first_name: "Tony",
    last_name: "Daly",
    date_of_birth: @date_of_birth,
    nhs_number: "943 476 0000"
  }

  setup %{} do
    ReadOnlyRepo.insert!(%EPJSUser{id: 789,
      Patient_ID: 200,
      Surname: "Bow",
      Forename: "Kat",
      NHS_Number: "uvhjbfnwqoekhfg8y9i",
      DOB: DateTime.from_naive!(~N[1989-01-01 00:00:00.00], "Etc/UTC"),
    })

    :ok
  end

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
