defmodule Healthlocker.PostTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.Post

  @valid_attrs %{content: "Hello world!"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?
  end
end
