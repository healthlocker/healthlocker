defmodule Healthlocker.UserController do
  use Healthlocker.Web, :controller

  alias Healthlocker.User
  alias Healthlocker.Plugs.Auth
  import Healthlocker.ComponentHelpers.Link

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    conn
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> redirect(to: "/users/#{user.id}/signup2", action: :signup2,
                                                     user: user)
      {:error, changeset} ->
        if String.contains?(elem(changeset.errors[:email], 0),
        "Sorry you cannot create an account") do
          user = Repo.get_by(User, email: changeset.changes[:email])
          cond do
            user.password_hash && user.data_access == nil ->
              conn
              |> redirect(to: "/users/#{user.id}/signup3", action: :signup3,
                                                           user: user)
            user.password_hash ->
              conn
              |> render("new.html", changeset: changeset)
            !user.password_hash ->
              conn
              |> redirect(to: "/users/#{user.id}/signup2", action: :signup2,
                                                           user: user)
            true ->
              conn
              |> render("new.html", changeset: changeset)
          end
        else
          conn
          |> render("new.html", changeset: changeset)
        end
    end
  end

  def signup2(conn, %{"user_id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.security_question(%User{})
    conn
    |> render("signup2.html", changeset: changeset,
                                 action: "/users/#{user.id}/#{:create2}",
                                 user: user)
  end

  def create2(conn, %{"user" => user_params, "user_id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.registration_changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> redirect(to: "/users/#{user.id}/signup3", action: :signup3,
                                                     user: user)
      {:error, changeset} ->
        conn
        |> render("signup2.html", changeset: changeset,
                     action: "/users/#{user.id}/#{:create2}",
                     user: user)
    end
  end

  def signup3(conn, %{"user_id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.data_access(%User{})
    conn
    |> render("signup3.html", changeset: changeset,
                                 action: "/users/#{user.id}/#{:create3}",
                                 user: user)
  end

  def create3(conn, %{"user" => user_params, "user_id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.data_access(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> Auth.login(user)
        |> put_flash(:info, ["Welcome to Healthlocker!
        Connect to your care team and record - find out more in ",
        link_to("Account.", to: account_path(conn, :index))])
        |> redirect(to: toolkit_path(conn, :index))
      {:error, changeset} ->
        conn
        |> render("signup3.html", changeset: changeset,
                       action: "/users/#{user.id}/#{:create3}",
                       user: user)
    end
  end
end
