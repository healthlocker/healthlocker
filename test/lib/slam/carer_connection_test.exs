defmodule Healthlocker.Slam.CarerConnectionTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.Slam.CarerConnection
  alias Healthlocker.{EPJSUser, ReadOnlyRepo}

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
    test "is invalid unless all the details are provided" do
      changeset = CarerConnection.changeset(%CarerConnection{}, %{})
      refute changeset.valid?
    end
  end
end
