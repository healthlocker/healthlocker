defmodule Healthlocker.UserTest do
  use Healthlocker.ModelCase

  alias Healthlocker.User

  @valid_attrs %{
    email: "me@example.com",
    password: "abc123",
    name: "MyName",
    security_question: "Favourite animal?",
    security_answer: "Cat",
    data_access: true,
    role: "service user"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
