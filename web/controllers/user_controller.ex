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
        # render(conn, "signup2.html", changeset: changeset, action: :update, user: user)
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def signup2(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.security_question(%User{})
    IO.inspect changeset
    render(conn, "signup2.html", changeset: changeset, action: "/users/#{user.id}/#{:update}")
  end

  def update(conn, %{"user" => user_params, "id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.registration_changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> Healthlocker.Auth.login(user)
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "signup2.html", changeset: changeset)
    end
  end

  #
  # def update(conn, %{"id" => id, "user" => user_params}) do
  #   user = Repo.get!(User, id)
  #   changeset = User.changeset(user, user_params)
  #
  #   case Repo.update(changeset) do
  #     {:ok, user} ->
  #       conn
  #       |> put_flash(:info, "User updated successfully.")
  #       |> redirect(to: user_path(conn, :show, user))
  #     {:error, changeset} ->
  #       render(conn, "edit.html", user: user, changeset: changeset)
  #   end
  # end
end
