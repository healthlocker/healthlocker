defmodule Healthlocker.AccountController do
  use Healthlocker.Web, :controller
  alias Healthlocker.{User, EPJSUser, ReadOnlyRepo}
  alias Healthlocker.Plugs.Auth
  use Timex

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id)
    changeset = User.update_changeset(user)
    render conn, "index.html", changeset: changeset, user: user,
              slam_id: user.slam_id, action: account_path(conn, :update)
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
                slam_id: user.slam_id, action: account_path(conn, :update))
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
    changeset = User.connect_slam(%User{})
    render conn, "slam.html", user: user, changeset: changeset,
                  action: account_path(conn, :check_slam)
  end

  def check_slam(conn, %{"user" => %{"Forename" => forename, "Surname" => surname, "NHS_Number" => nhs, "DOB" => dob}}) do
    slam_user = ReadOnlyRepo.one(from e in EPJSUser,
                where: e."Forename" == ^forename
                and e."Surname" == ^surname
                and e."NHS_Number" == ^nhs)
    # TODO DOB input doesn't match type in db. Removed for now, but need to fix
    if slam_user do
      user = Repo.get!(User, conn.assigns.current_user.id)
      User.connect_slam(user, %{"slam_id" => slam_user."Patient_ID"})
          |> Repo.update!
      slam_changeset = EPJSUser.changeset(slam_user)
      conn
      |> put_flash(:info, "SLaM account connected!")
      |> render("index.html", changeset: slam_changeset, user: slam_user,
                slam_id: slam_user.id, action: account_path(conn, :update))
    else
      conn
      |> put_flash(:error, "Details do not match. Please try again later")
      |> redirect(to: account_path(conn, :slam))
    end
  end

  def datetime_birthday(date_string) do
    date_string
    |> Timex.parse!("%d/%m/%Y", :strftime)
    |> DateTime.from_naive!("Etc/UTC")
  end
end
