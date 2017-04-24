defmodule Healthlocker.CarerTest do
  use Healthlocker.ModelCase
  alias Healthlocker.{Carer, User}

  test "no carers" do
    user = EctoFactory.insert(:user, email: "bob@healthlocker.uk")
    carers = Repo.all(Ecto.assoc(user, :carers))

    assert length(carers) == 0
  end

  test "add a carer" do
    user = EctoFactory.insert(:user, email: "bob@healthlocker.uk")
    carer = EctoFactory.insert(:user, email: "mary@healthlocker.uk")

    relationship = %Carer{caring: user, carer: carer}
    {:ok, inserted_relationship} = Repo.insert(relationship)

    carers = Repo.all(Ecto.assoc(user, :carers))
    carer_ids = Enum.map(carers, fn(carer) -> carer.id end)
    assert carer.id in carer_ids
  end

  test "service user has multiple carers" do
    user = EctoFactory.insert(:user, email: "bob@healthlocker.uk")
    carer1 = EctoFactory.insert(:user, email: "mary@healthlocker.uk")
    carer2 = EctoFactory.insert(:user, email: "dave@healthlocker.uk")

    Repo.insert(%Carer{caring: user, carer: carer1})
    Repo.insert(%Carer{caring: user, carer: carer2})

    carers = Repo.all(Ecto.assoc(user, :carers))
    assert length(carers) == 2
  end

  test "caring for multiple people" do
    bob = EctoFactory.insert(:user, email: "bob@healthlocker.uk")
    dave = EctoFactory.insert(:user, email: "dave@healthlocker.uk")
    carer = EctoFactory.insert(:user, email: "mary@healthlocker.uk")

    Repo.insert(%Carer{caring: bob, carer: carer})
    Repo.insert(%Carer{caring: dave, carer: carer})

    caring = Repo.all(Ecto.assoc(carer, :caring))
    assert length(caring) == 2
  end
end
