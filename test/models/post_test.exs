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

  test "featured_story returns a story" do
    post  = fixture(:post)
    story = Post |> Post.featured_story |> Repo.one
    assert String.contains? story.content, "#story"
  end

  test "featured_story does not return any tips" do
    post  = fixture(:post)
    story = Post |> Post.featured_story |> Repo.one
    refute String.contains? story.content, "#tip"
  end

  test "featured_tip returns a tip" do
    post  = fixture(:post)
    tip = Post |> Post.featured_tip |> Repo.one
    assert String.contains? tip.content, "#tip"
  end

  test "featured_tip does not return any stories" do
    post  = fixture(:post)
    tip = Post |> Post.featured_tip |> Repo.one
    refute String.contains? tip.content, "#story"
  end
end
