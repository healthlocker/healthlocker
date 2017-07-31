defmodule Healthlocker.CaseloadController do
  use Healthlocker.Web, :controller

  alias Healthlocker.{User, Plugs.Auth, QueryEpjs}

  def index(conn, %{"userdata" => user_data}) do
    # next 2 lines replaced with http request
    %{
      "decrypted_user_guid" => decrypted_user_guid,
      "decrypted_time_str" => decrypted_time_str,
      "clinician" => clinician
     } = QueryEpjs.query_epjs("http://localhost:4001/team-member/clinician-connection/find-clinician?user_data=", user_data)
    compared_time = compare_time(decrypted_time_str)

    # if decrypted_time_str converteted to DateTime > than dateTime.now == true -> the rest of case
    # if false -> conn |> put_flash(:error, "Authentication failed") |> redirect(to: page_path(conn, :index))
    case compared_time do
      :gt ->
        case Repo.get_by(User, user_guid: decrypted_user_guid) do
          nil ->
            case clinician do
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
        patients = get_patients(clinician)
        render(conn, "index.html", hl_users: patients.hl_users, non_hl: patients.non_hl)
      true ->
        conn
        |> put_flash(:error, "Authentication failed")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def get_patients(clinician) do
    %{"patient_ids" => patient_ids, "patients" => patients} = QueryEpjs.query_epjs("http://localhost:4001/team-member/clinician-connection/get-patients?clinician=", clinician)

    hl_users = patient_ids
              |> Enum.map(fn id ->
                Repo.all(from u in User,
                where: u.slam_id == ^id,
                preload: [carers: :rooms],
                preload: [:rooms])
              end)
              |> Enum.concat

    non_hl =
      patients
      |> Enum.reject(fn user ->
        Enum.any?(hl_users, fn hl ->
          user."Patient_ID" == hl.slam_id
        end)
      end)
    %{hl_users: hl_users, non_hl: non_hl}
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
