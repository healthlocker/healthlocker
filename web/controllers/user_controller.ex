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
      {:ok, _user} ->
        render(conn, "signup2.html", changeset: changeset, action: :create2)
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def signup2(conn, _params) do
    changeset = User.security_question(%User{})
    render(conn, "signup2.html", changeset: changeset)
  end

  def create2(conn, %{"signup2" => signup2_params}) do
    changeset = User.registration_changeset(%User{}, signup2_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Healthlocker.Auth.login(user)
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "signup.html", changeset: changeset)
    end
  end
end
