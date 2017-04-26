defmodule Healthlocker.CaseloadController do
  use Healthlocker.Web, :controller

  alias Healthlocker.{EPJSTeamMember, EPJSUser, ReadOnlyRepo, User}

  def index(conn, _params) do
    # only have one known clinician right now, so using this to get info
    # will need to grab the clinician_id from the token used to go from
    # epjs to HL
    clinician_id = 63
    patient_ids = EPJSTeamMember
                  |> EPJSTeamMember.patient_ids(clinician_id)
                  |> ReadOnlyRepo.all

    hl_users = patient_ids
              |> Enum.map(fn x ->
                Repo.all(from u in User,
                where: u.slam_id == ^x)
              end)
              |> Enum.concat

    non_hl = patient_ids
              |> Enum.map(fn x ->
                ReadOnlyRepo.all(from e in EPJSUser,
                where: e."Patient_ID" == ^x)
              end)
              |> Enum.concat
              |> Enum.reject(fn x ->
                Enum.any?(hl_users, fn x2 ->
                  x."Patient_ID" == x2.slam_id
                end)
              end)
    render(conn, "index.html", hl_users: hl_users, non_hl: non_hl)
  end
end
