defmodule Healthlocker.UserController do
  use Healthlocker.Web, :controller

  alias Healthlocker.User

  def index(conn, _params) do
    render conn, "index.html"
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> redirect(to: "/users/#{user.id}/signup2", action: :signup2, user: user)
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def signup2(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.security_question(%User{})
    render(conn, "signup2.html", changeset: changeset, action: "/users/#{user.id}/#{:create2}", user: user)
  end

  def create2(conn, %{"user" => user_params, "id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.registration_changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> redirect(to: "/users/#{user.id}/signup3", action: :signup3, user: user)
      {:error, changeset} ->
        render(conn, "signup2.html", changeset: changeset, action: "/users/#{user.id}/#{:create2}", user: user)
    end
  end

  def signup3(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.data_access(%User{})
    render(conn, "signup3.html", changeset: changeset, action: "/users/#{user.id}/#{:create3}", user: user)
  end

  def create3(conn, %{"user" => user_params, "id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.data_access(%User{}, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> Healthlocker.Auth.login(user)
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "signup3.html", changeset: changeset, action: "/users/#{user.id}/#{:create3}", user: user)
    end
  end
end
