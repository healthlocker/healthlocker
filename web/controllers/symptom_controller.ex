defmodule Healthlocker.SymptomController do
  use Healthlocker.Web, :controller
  alias Healthlocker.Symptom

  def new(conn, _params) do
    changeset = Symptom.changeset(%Symptom{})
    conn
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"symptom" => symptom}) do
    changeset =
      conn.assigns.current_user
      |> build_assoc(:symptoms)
      |> Symptom.changeset(symptom)

    case Repo.insert(changeset) do
      {:ok, _symptom} ->
        conn
        |> redirect(to: symptom_tracker_path(conn, :new))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "You've already added a problem. Track it in the problem tracker.")
        |> render("new.html", changeset: changeset)
    end
  end
end
