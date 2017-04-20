defmodule Healthlocker.PostTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.Post
  import Healthlocker.Fixtures

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

  test "find_tips returns all tips" do
    fixture(:post)
    tips = Post |> Post.find_tips |> Repo.all
    assert Kernel.length(tips) == 2
  end

  test "find_stories returns all stories" do
    fixture(:post)
    stories = Post |> Post.find_stories |> Repo.all
    assert Kernel.length(stories) == 3
  end

  test "find_tags returns tips with the correct tag type" do
    fixture(:post)
    tip = Post |> Post.find_tags(%{"tag" => "connect"}) |> Repo.all |> List.first
    assert String.contains? tip.content, "#connect"
  end

end
