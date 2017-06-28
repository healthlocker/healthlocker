defmodule Healthlocker.CaseloadController do
  use Healthlocker.Web, :controller

  alias Healthlocker.{EPJSTeamMember, EPJSUser, User, Plugs.Auth, DecryptUser}

  def index(conn, %{"userdata" => user_data}) do
    decrypted_user_guid = DecryptUser.decrypt_user_data(user_data)
    query = from etm in EPJSTeamMember, where: etm."User_Guid" == ^decrypted_user_guid

    case Repo.get_by(User, user_guid: decrypted_user_guid) do
      nil ->
        case ReadOnlyRepo.all(query) do
          [] ->
            conn
            |> put_flash(:error, "Authentication failed")
            |> redirect(to: page_path(conn, :index))
          [epjs_user | _rest] ->
            changeset = User.clinician_changeset(%User{}, epjs_user)
            case Repo.insert(changeset) do
              {:ok, user} ->
                patients = get_patients(user)
                conn
                |> Auth.login(user)
                |> render("index.html", hl_users: patients.hl_users, non_hl: patients.non_hl)
              {:error, _} ->
                conn
                |> put_flash(:error, "Something went wrong. Please try again.")
                |> redirect(to: page_path(conn, :index))
            end
        end
      user ->
        patients = get_patients(user)
        conn
        |> Auth.login(user)
        |> render("index.html", hl_users: patients.hl_users, non_hl: patients.non_hl)
    end
  end

  def index(conn, _params) do
    cond do
      !conn.assigns[:current_user] ->
        conn
        |> put_flash(:error,  "You must be logged in to access that page!")
        |> redirect(to: login_path(conn, :index))
        |> halt
      conn.assigns.current_user.user_guid ->
        clinician = conn.assigns.current_user
        patients = get_patients(clinician)
        render(conn, "index.html", hl_users: patients.hl_users, non_hl: patients.non_hl)
      true ->
        conn
        |> put_flash(:error, "Authentication failed")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def get_patients(clinician) do
    patient_ids = EPJSTeamMember
                  |> EPJSTeamMember.patient_ids(clinician.email)
                  |> ReadOnlyRepo.all

    hl_users = patient_ids
              |> Enum.map(fn id ->
                Repo.all(from u in User,
                where: u.slam_id == ^id,
                preload: [carers: :rooms],
                preload: [:rooms])
              end)
              |> Enum.concat

    non_hl = patient_ids
              |> Enum.map(fn id ->
                ReadOnlyRepo.all(from e in EPJSUser,
                where: e."Patient_ID" == ^id)
              end)
              |> Enum.concat
              |> Enum.reject(fn user ->
                Enum.any?(hl_users, fn hl ->
                  user."Patient_ID" == hl.slam_id
                end)
              end)
    %{hl_users: hl_users, non_hl: non_hl}
  end
end
