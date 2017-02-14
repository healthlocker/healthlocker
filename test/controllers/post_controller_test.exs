defmodule Healthlocker.PostControllerTest do
  use Healthlocker.ConnCase
  import Healthlocker.Fixtures

  alias Healthlocker.Post
  @valid_attrs %{content: "some content #story"}
  @invalid_attrs %{}

  # setup do
  #   user = insert_user()
  #   conn = assign(build_conn(), :current_user, user)
  #   {:ok, conn: conn, user: user}
  # end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_path(conn, :index)
    assert html_response(conn, 200) =~ "Stories"
  end

  test "requires user authentication on new post action", %{conn: conn} do
    conn = get conn, post_path(conn, :new)
    assert html_response(conn, 302)
    assert conn.halted
  end

  # test "renders form for new resources", %{conn: conn, user: user} do
  #   conn = get conn, post_path(conn, :new)
  #   assert html_response(conn, 200) =~ "Post a story or tip"
  # end

  # test "creates resource and redirects when data is valid", %{conn: conn} do
  #   conn = post conn, post_path(conn, :create), post: @valid_attrs
  #   assert redirected_to(conn) == post_path(conn, :index)
  #   assert Repo.get_by(Post, @valid_attrs)
  # end
  #
  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, post_path(conn, :create), post: @invalid_attrs
  #   assert html_response(conn, 200) =~ "Post a story or tip"
  # end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, post_path(conn, :show, -1)
    end
  end

end
