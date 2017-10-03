defmodule Healthlocker.AccountController do
  use Healthlocker.Web, :controller
  alias Healthlocker.{User, EPJSUser, ReadOnlyRepo, Slam.ConnectSlam,
                      Slam.DisconnectSlam, Carer}
  alias Healthlocker.Plugs.Auth
  use Timex

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id
    user = User
          |> Repo.get!(user_id)
          |> Repo.preload(:caring)
    changeset = User.update_changeset(user)
    conn
    |> render("index.html", changeset: changeset, user: user,
              slam_id: user.slam_id, action: account_path(conn, :update))
  end

  def update(conn, %{"user" => user_params}) do
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id) |> Repo.preload(:caring)

    changeset = User.update_changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, _params} ->
        conn
        |> put_flash(:info, "Updated successfully!")
        |> redirect(to: account_path(conn, :index))
      {:error, changeset} ->
        conn
        |> render("index.html", changeset: changeset, user: user,
                slam_id: user.slam_id, action: account_path(conn, :update))
    end
  end

  def disconnect(conn, _params) do
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id)

    multi = DisconnectSlam.disconnect_su(user)
    case Repo.transaction(multi) do
      {:ok, _params} ->
        conn
        |> put_flash(:info, "Account disconnected from your care team and health record.")
        |> redirect(to: account_path(conn, :index))
      {:error, changeset} ->
        conn
        |> render("index.html", changeset: changeset, user: user,
                slam_id: user.slam_id, action: account_path(conn, :update))
    end
  end

  def consent(conn, _params) do
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id)
    changeset = User.update_data_access(user)
    conn
    |> render("consent.html", changeset: changeset, user: user,
                        action: account_path(conn, :update_consent))
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
        conn
        |> render("consent.html", changeset: changeset, user: user,
                  action: account_path(conn, :update_consent))
    end
  end

  def edit_security(conn, _params) do
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id)
    changeset = User.security_question(%User{})
    conn
    |> render("edit_security.html", changeset: changeset, user: user,
                    action: account_path(conn, :update_security))
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
          conn
          |> render("edit_security.html", changeset: changeset, user: user,
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
    conn
    |> render("edit_password.html", changeset: changeset, user: user,
                    action: account_path(conn, :update_password))
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
            conn
            |> render("edit_password.html", changeset: changeset, user: user,
                         action: account_path(conn, :update_password))
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
    conn
    |> render("slam.html", user: user, changeset: changeset,
                  action: account_path(conn, :check_slam))
  end

  def check_slam(conn, %{"user" => %{
    "Forename" => forename,
    "Surname" => surname,
    "NHS_Number" => nhs,
    "DOB" => dob,
    "c4c" => c4c}}) do
    # converts birthday string to datetime
    birthday = case Regex.match?(~r/\d{2}\/\d{2}\/\d{4}/, dob) do
      true ->
        datetime_birthday(dob)
      _ ->
        conn
        |> put_flash(:error, "Details do not match. Please try again later")
        |> redirect(to: account_path(conn, :slam))
    end
    # removes spaces from nhs number if present
    nhs_no = if nhs != "", do: String.split(nhs, " ") |> List.to_string
    case check_age(birthday) do
      :gt ->
        # go to error page
        conn
        |> put_flash(:error, "We are unable to connect your account as you are under the age of 16. You can continue to use Healthlocker without this connection.")
        |> redirect(to: page_path(conn, :index))
      _ ->
        # 16 or over, go through slam connection
        slam_user = if forename != "" && surname != "" && nhs != "" && dob != "" do
          ReadOnlyRepo.one(from e in EPJSUser,
            where: e."Forename" == ^forename
            and e."Surname" == ^surname
            and e."NHS_Number" == ^nhs_no
            and e."DOB" == fragment("convert (datetime, ?, 103)", ^birthday)
          )
        else
          nil
        end

        if slam_user do
          user = conn.assigns.current_user |> Repo.preload(:caring)
          carer_query = from c in Carer, where: c.slam_id == ^slam_user."Patient_ID"
          carer = case Carer |> Repo.all(carer_query) do
            [] ->
              nil
            carer ->
              carer
          end

          multi = ConnectSlam.connect_su_and_create_rooms(user, %{
            first_name: forename,
            last_name: surname,
            slam_id: slam_user."Patient_ID",
            c4c: c4c}, carer)
          changeset = User.update_changeset(user)
          case Repo.transaction(multi) do
            {:ok, result} ->
              conn
              |> put_flash(:info, "Account connected!")
              |> redirect(to: account_path(conn, :index), changeset: changeset, user: result.user,
                        slam_id: slam_user."Patient_ID", action: account_path(conn, :update))
            {:error, _type, changeset, _} ->
              conn
              |> put_flash(:error, "Something went wrong")
              |> render("slam.html", user: user, changeset: changeset,
                            action: account_path(conn, :check_slam))
          end
        else
          conn
          |> put_flash(:error, "Details do not match. Please try again later")
          |> redirect(to: account_path(conn, :slam))
        end
    end
  end

  def datetime_birthday(date_string) do
    date_string
    |> Timex.parse!("%d/%m/%Y", :strftime)
    |> Timex.format!("%d/%m/%Y", :strftime)
  end

  def check_age(birthday) do
    sixteen_years_ago = Timex.shift(NaiveDateTime.utc_now, years: -16)

    birthday
    |> Timex.parse!("%d/%m/%Y", :strftime)
    |> NaiveDateTime.compare(sixteen_years_ago)
  end
end
