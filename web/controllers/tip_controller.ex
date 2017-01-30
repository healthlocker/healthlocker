defmodule Healthlocker.TipController do
  use Healthlocker.Web, :controller

  alias Healthlocker.Tip

  def index(conn, params) do
    tips = if params["tag"] do
            Repo.all(from t in Tip, where: t.tag == ^params["tag"])
          else
            Repo.all(Tip)
          end
    render(conn, "index.html", tips: tips)
  end

  def new(conn, _params) do
    changeset = Tip.changeset(%Tip{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tip" => tip_params}) do
    changeset = Tip.changeset(%Tip{}, tip_params)

    case Repo.insert(changeset) do
      {:ok, _tip} ->
        conn
        |> put_flash(:info, "Tip created successfully.")
        |> redirect(to: tip_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

end
