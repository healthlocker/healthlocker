defmodule Healthlocker.TipController do
  use Healthlocker.Web, :controller

  alias Healthlocker.Tip

  def index(conn, _params) do
    tips = Repo.all(Tip)
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

  def show(conn, %{"id" => id}) do
    tip = Repo.get!(Tip, id)
    render(conn, "show.html", tip: tip)
  end


end
