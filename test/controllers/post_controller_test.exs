defmodule Healthlocker.PostControllerTest do
  use Healthlocker.ConnCase
  import Healthlocker.Fixtures

  alias Healthlocker.Post
  alias Healthlocker.User
  @valid_attrs %{content: "some content #story"}
  @invalid_attrs %{}

  describe "paths need current_user" do
    setup do
      %User{
        id: 123456,
        name: "MyName",
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        role: "admin"
      } |> Repo.insert

      post = Repo.insert!(%Post{
        content: "# title \n\n more stuff \n\n #story",
        user_id: 123_456
      })

      {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123456)),
            post: post}
    end

    test "renders edit form", %{conn: conn, post: post} do
      conn = get conn, post_path(conn, :edit, post)
      assert html_response(conn, 200) =~ "Edit post"
    end

    test "updates post with valid data", %{conn: conn, post: post} do
      conn = put conn, post_path(conn, :update, post), post: %{
        content: "**title** \n\n more stuff \n\n #story"
      }
      updated = Post
              |> Repo.get_by!(content: "**title** \n\n more stuff \n\n #story")
      assert redirected_to(conn) == post_path(conn, :show, post)
      assert updated
    end

    test "does not update post with invalid data", %{conn: conn, post: post} do
      conn = put conn, post_path(conn, :update, post), post: %{
        content: ""
      }
      updated = Repo.get_by(Post, content: "")
      assert html_response(conn, 200) =~ "Edit post"
      refute updated
    end

    test "renders form for new resources", %{conn: conn} do
      conn = get conn, post_path(conn, :new)
      assert html_response(conn, 200) =~ "Post a story or tip"
    end

    test "creates resource and redirects when data is valid", %{conn: conn} do
      conn = post conn, post_path(conn, :create), post: @valid_attrs
      assert redirected_to(conn) == post_path(conn, :new)
      assert Repo.get_by(Post, @valid_attrs)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, post_path(conn, :create), post: @invalid_attrs
      assert html_response(conn, 200) =~ "Post a story or tip"
    end
  end

  describe "paths are halted without current_user" do
    test "requires user authentication on new post action", %{conn: conn} do
      conn = get conn, post_path(conn, :new)
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "creates resource and redirects when data is valid", %{conn: conn} do
      conn = post conn, post_path(conn, :create), post: @valid_attrs
      assert html_response(conn, 302)
      assert conn.halted
    end
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_path(conn, :index)
    assert html_response(conn, 200) =~ "Stories"
  end

  test "likes updates posts_likes", %{conn: conn} do
    fixture(:post)
    post = Repo.get_by!(Post, content: "Another #tip #beactive")
    conn = post conn, "/posts/#{post.id}/likes"
    assert html_response(conn, 302)
    assert conn.halted
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, post_path(conn, :show, -1)
    end
  end
end
