defmodule Healthlocker.CaseloadController do
  use Healthlocker.Web, :controller

  alias Healthlocker.{EPJSTeamMember, EPJSUser, User, Plugs.Auth, DecryptUser, Carer}

  def index(conn, %{"userdata" => user_data}) do
    [decrypted_user_guid, decrypted_time_str] = DecryptUser.decrypt_user_data(user_data)
    query = from etm in EPJSTeamMember, where: etm."User_Guid" == ^decrypted_user_guid
    compared_time = compare_time(decrypted_time_str)

    # if decrypted_time_str converteted to DateTime > than dateTime.now == true -> the rest of case
    # if false -> conn |> put_flash(:error, "Authentication failed") |> redirect(to: page_path(conn, :index))
    case compared_time do
      :gt ->
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
                    hl_patients = get_hl_patients(user)
                    conn
                    |> Auth.login(user)
                    |> render("index.html", hl_users: hl_patients.hl_users,
                      carers: hl_patients.carers, patients_list: hl_patients.non_hl_ids_list)
                  {:error, _} ->
                    conn
                    |> put_flash(:error, "Something went wrong. Please try again.")
                    |> redirect(to: page_path(conn, :index))
                end
            end
          user ->
            hl_patients = get_hl_patients(user)
            conn
            |> Auth.login(user)
            |> render("index.html", hl_users: hl_patients.hl_users,
              carers: hl_patients.carers, patients_list: hl_patients.non_hl_ids_list)
        end
      _ ->
        conn
        |> put_flash(:error, "Authentication failed, token expired")
        |> redirect(to: page_path(conn, :index))
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
        hl_patients = get_hl_patients(clinician)
        conn
        |> render("index.html", hl_users: hl_patients.hl_users,
          carers: hl_patients.carers, patients_list: hl_patients.non_hl_ids_list)
      true ->
        conn
        |> put_flash(:error, "Authentication failed")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def get_hl_patients(clinician) do
    # get all patient ids for a clinician
    patient_ids =
      EPJSTeamMember
      |> EPJSTeamMember.patient_ids(clinician.email)
      |> ReadOnlyRepo.all
      |> Enum.uniq

    # for each Patient id, check if it exists in HL database to get the user details
    hl_users =
      patient_ids
      |> Enum.map(fn id ->
        Repo.all(from u in User,
        where: u.slam_id == ^id,
        preload: [carers: :rooms],
        preload: [:rooms])
      end)
      |> Enum.concat

    # remove ids from list which we already have from HL database
    non_hl_ids_list =
      patient_ids
      |> Enum.reject(fn id ->
        Enum.any?(hl_users, fn user ->
          id == user.slam_id
        end)
      end)

    # get any carers that have connected without a service user connected in HL
    carers = get_carers_for_unconnected_users(non_hl_ids_list)

    %{hl_users: hl_users, non_hl_ids_list: non_hl_ids_list, carers: carers}
  end

  def get_carers_for_unconnected_users(non_hl_ids_list) do
    carer_connections =
      non_hl_ids_list
      |> Enum.map(fn id ->
        Repo.all(from c in Carer,
        where: c.slam_id == ^id)
      end)
      |> Enum.concat

    carer_connections
    |> Enum.map(fn carer_conn ->
      su =
        ReadOnlyRepo.all(from e in EPJSUser,
        where: e."Patient_ID" == ^carer_conn.slam_id)

      carer =
        Repo.get(User, carer_conn.carer_id)
        |> Repo.preload(:rooms)
        |> Repo.preload(:caring)

      %{carer | caring: su}
    end)
  end

  def compare_time(time_str) do
    case DateTime.from_iso8601(time_str <> "Z") do
      {:ok, datetime, _} ->
        DateTime.compare(datetime, DateTime.utc_now)
      _ ->
        :lt
    end
  end
end
