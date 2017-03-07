defmodule Healthlocker.AccountController do
  use Healthlocker.Web, :controller

  plug :authenticate

  alias Healthlocker.User
  alias Healthlocker.SlamUser

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id)
    if user.slam_user_id do
      slam_user = Repo.get!(SlamUser, user.slam_user_id)
      slam_changeset = SlamUser.changeset(slam_user)
      # needs to go to different update action
      render conn, "index.html", changeset: slam_changeset, user: user,
        slam_user_id: user.slam_user_id, action: account_path(conn, :update)
    else
      changeset = User.update_changeset(user)
      render conn, "index.html", changeset: changeset, user: user,
      slam_user_id: nil, action: account_path(conn, :update)
    end
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
                slam_user_id: nil, action: account_path(conn, :update))
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

    if user_params["security_check"] == user.security_answer do
      changeset = User.security_question(user, user_params)

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
      conn
      |> put_flash(:error, "Security answer does not match")
      |> redirect(to: account_path(conn, :edit_security))
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

    case Healthlocker.Auth.check_password(conn, user_id, user_params["password_check"], repo: Repo) do
      {:ok, conn} ->
        changeset = User.update_password(user, user_params)

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
        conn
        |> put_flash(:error, "Incorrect current password")
        |> redirect(to: account_path(conn, :edit_password))
    end
  end

  def slam(conn, _params) do
    # need to get slam_user changeset here and pass in to form
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id)
    changeset = User.connect_slam(%User{})
    render conn, "slam.html", user: user, changeset: changeset,
                action: account_path(conn, :check_slam)
  end

  def check_slam(conn, %{"user" => %{"first_name" => first_name, "last_name" => last_name, "nhs_number" => nhs, "date_of_birth" => dob}}) do
    slam_user = Repo.one(from su in SlamUser,
                where: su.first_name == ^first_name
                and su.last_name == ^last_name
                and su.nhs_number == ^nhs
                and su.date_of_birth == ^dob)
                |> Repo.preload(:address)
                |> Repo.preload(:user)
    if slam_user do
      user = Repo.get!(User, conn.assigns.current_user.id)
      User.connect_slam(user, %{"slam_user_id" => slam_user.id})
          |> Repo.update!
      slam_changeset = SlamUser.changeset(slam_user)
      conn
      |> put_flash(:info, "SLaM account connected!")
      |> render("index.html", changeset: slam_changeset, user: slam_user, slam_user_id: slam_user.id,
      action: account_path(conn, :update))
      # render index.html with slam user details
    else
      conn
      |> put_flash(:error, "Details do not match. Please try again later")
      |> redirect(to: account_path(conn, :slam))
    end
  end

  def slam_help(conn, _params) do
    render conn, "slam_help.html"
  end

  def nhs_help(conn, _params) do
    render conn, "nhs_help.html"
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
