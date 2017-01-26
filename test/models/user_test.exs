defmodule Healthlocker.UserTest do
  use Healthlocker.ModelCase

  alias Healthlocker.User

  @valid_attrs %{dob: %{day: 17, month: 4, year: 2010}, email: "some content", name: "some content", password: "some content", pin: "some content", securityanswer: "some content", securityquestion: "some content"}
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
