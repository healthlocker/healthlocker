defmodule Healthlocker.AccountController do
  use Healthlocker.Web, :controller

  plug :authenticate

  alias Healthlocker.User

  def index(conn, params) do
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id)
    changeset = User.update_changeset(user)
    render conn, "index.html", changeset: changeset, action: "account/update", user: user
  end

  def update(conn, %{"user" => user_params}) do
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id)

    changeset = User.update_changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, _params} ->
        conn
        |> put_flash(:info, "Updated successfully!")
        |> redirect(to: account_path(conn, :index))
      {:error, changeset} ->
        render(conn, "index.html", changeset: changeset, user: user, action: "account/update")
    end
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error,  "You must be logged in to access that page!")
      |> redirect(to: login_path(conn, :index))
      |> halt()
    end
  end
end
