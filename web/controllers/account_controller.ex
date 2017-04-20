defmodule Healthlocker.AccountController do
  use Healthlocker.Web, :controller
  alias Healthlocker.User
  alias Healthlocker.Plugs.Auth

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id)
    changeset = User.update_changeset(user)
    render conn, "index.html", changeset: changeset, user: user,
              slam_user: nil, action: account_path(conn, :update)
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
        render(conn, "index.html", changeset: changeset, user: user,
                slam_user: nil, action: account_path(conn, :update))
    end
  end

  def consent(conn, _params) do
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id)
    changeset = User.update_changeset(user)
    render conn, "consent.html", changeset: changeset, user: user,
                        action: account_path(conn, :update_consent)
  end

  def update_consent(conn, %{"user" => user_params}) do
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id)

    changeset = User.update_data_access(user, user_params)

    case Repo.update(changeset) do
      {:ok, _params} ->
        conn
        |> put_flash(:info, "Updated successfully!")
        |> redirect(to: account_path(conn, :consent))
      {:error, changeset} ->
        render(conn, "consent.html", changeset: changeset, user: user,
                  action: account_path(conn, :update_consent))
    end
  end

  def security(conn, _params) do
    render conn, "security.html"
  end

  def edit_security(conn, _params) do
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id)
    changeset = User.security_question(%User{})
    render conn, "edit_security.html", changeset: changeset, user: user,
                                       action: account_path(conn, :update_security)
  end

  def update_security(conn, %{"user" => user_params}) do
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id)

    changeset = User.security_question(user, user_params)
    if user_params["security_check"] == user.security_answer do

      case Repo.update(changeset) do
        {:ok, _params} ->
          conn
          |> put_flash(:info, "Updated successfully!")
          |> redirect(to: account_path(conn, :edit_security))
        {:error, changeset} ->
          render(conn, "edit_security.html", changeset: changeset, user: user,
                    action: account_path(conn, :update_security))
      end
    else
      changeset = changeset
      |> Ecto.Changeset.add_error(:security_check, "Does not match")

      conn
      |> put_flash(:error, "Security answer does not match")
      |> render("edit_security.html", changeset: %{changeset | action: :update}, user: user,
                action: account_path(conn, :update_security))
    end
  end

  def edit_password(conn, _params) do
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id)
    changeset = User.password_changeset(%User{})
    render conn, "edit_password.html", changeset: changeset, user: user,
                                       action: account_path(conn, :update_password)
  end

  def update_password(conn, %{"user" => user_params}) do
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id)

    changeset = User.update_password(user, user_params)
    case Auth.check_password(conn, user_id, user_params["password_check"], repo: Repo) do
      {:ok, conn} ->

        case Repo.update(changeset) do
          {:ok, _params} ->
            conn
            |> put_flash(:info, "Password updated successfully!")
            |> redirect(to: account_path(conn, :edit_password))
          {:error, changeset} ->
            render conn, "edit_password.html", changeset: changeset, user: user,
                         action: account_path(conn, :update_password)
        end
      {:error, _reason, conn} ->
        changeset = changeset
        |> Ecto.Changeset.add_error(:password_check, "Does not match")

        conn
        |> put_flash(:error, "Incorrect current password")
        |> render("edit_password.html", changeset: %{changeset | action: :update},
                user: user, action: account_path(conn, :update_password))
    end
  end

  def slam(conn, _params) do
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id)
    render conn, "slam.html", user: user
  end

  def slam_help(conn, _params) do
    render conn, "slam_help.html"
  end

  def nhs_help(conn, _params) do
    render conn, "nhs_help.html"
  end
end
