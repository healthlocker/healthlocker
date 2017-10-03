defmodule Healthlocker.Slam.CarerConnectionTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.Slam.CarerConnection
  alias Healthlocker.{EPJSUser, ReadOnlyRepo}

  @valid_attrs %{
    forename: "Kat",
    surname: "Bow",
    date_of_birth: "01/01/1989",
    nhs_number: "uvhjbfnwqoekhfg8y9i"
  }
  @invalid_attrs %{
    forename: "Tony",
    surname: "Daly",
    date_of_birth: "01/01/1989",
    nhs_number: "943 476 0000"
  }

  setup %{} do
    ReadOnlyRepo.insert!(%EPJSUser{
      Patient_ID: 200,
      Surname: "Bow",
      Forename: "Kat",
      NHS_Number: "uvhjbfnwqoekhfg8y9i",
      DOB: DateTime.from_naive!(~N[1989-01-01 00:00:00.00], "Etc/UTC"),
    })

    :ok
  end

  describe "changeset" do
    # can only test with mssql database set up
    # test "is valid when all details match" do
    #   changeset = CarerConnection.changeset(%CarerConnection{}, @valid_attrs)
    #   assert changeset.valid?
    # end

    # can only test with mssql database set up
    # test "is invalid if any of the details do not match" do
    #   changeset = CarerConnection.changeset(%CarerConnection{}, @invalid_attrs)
    #   refute changeset.valid?
    # end

    test "is invalid unless all the details are provided" do
      changeset = CarerConnection.changeset(%CarerConnection{}, %{})
      refute changeset.valid?
    end
  end
end
