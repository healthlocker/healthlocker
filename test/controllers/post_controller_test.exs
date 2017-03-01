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
        password_hash: Comeonin.Bcrypt.hashpwsalt("password")
      } |> Repo.insert

      {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123456)) }
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
  end


  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, post_path(conn, :show, -1)
    end
  end

end
