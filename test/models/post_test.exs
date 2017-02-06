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

  test "find_stories returns a story" do
    post  = fixture(:post)
    story = Post |> Post.find_stories |> Repo.one
    assert String.contains? story.content, "#story"
  end

  test "find_stories does not return any tips" do
    post  = fixture(:post)
    story = Post |> Post.find_stories |> Repo.one
    refute String.contains? story.content, "#tip"
  end

  test "find_tips returns a tip" do
    post  = fixture(:post)
    tip = Post |> Post.find_tips |> Repo.one
    assert String.contains? tip.content, "#tip"
  end

  test "find_tips does not return any stories" do
    post  = fixture(:post)
    tip = Post |> Post.find_tips |> Repo.one
    refute String.contains? tip.content, "#story"
  end
end
