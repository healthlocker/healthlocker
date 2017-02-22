defmodule Healthlocker.AccountController do
  use Healthlocker.Web, :controller

  alias Healthlocker.User

  def index(conn, params) do
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id)
    changeset = User.update_changeset(user)
    render conn, "index.html", changeset: changeset, action: "account/update", user: user
  end

  def update(conn, %{"user" => user_params}) do
    IO.inspect user_params
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id)

    changeset = User.update_changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, _params} ->
        conn
        |> put_flash(:info, "Updated successfully!")
        |> redirect(to: account_path(conn, :index))
      {:error, changeset} ->
        render(conn, "index.html", changeset: changeset, user: user)
    end
  end
end
