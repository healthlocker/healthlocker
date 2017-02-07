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

  test "find_single_story returns a story" do
    fixture(:post)
    story = Post |> Post.find_single_story |> Repo.one
    assert String.contains? story.content, "#story"
  end

  test "find_single_story does not return any tips" do
    fixture(:post)
    story = Post |> Post.find_single_story |> Repo.one
    refute String.contains? story.content, "#tip"
  end

  test "find_single_tip returns a tip" do
    fixture(:post)
    tip = Post |> Post.find_single_tip |> Repo.one
    assert String.contains? tip.content, "#tip"
  end

  test "find_single_tip does not return any stories" do
    fixture(:post)
    tip = Post |> Post.find_single_tip |> Repo.one
    refute String.contains? tip.content, "#story"
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
    post = fixture(:post)
    tip = Post |> Post.find_tags(%{"tag" => "connect"}) |> Repo.all |> List.first
    assert String.contains? tip.content, "#connect"
  end

end
