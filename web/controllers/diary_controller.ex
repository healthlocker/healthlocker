defmodule Healthlocker.DiaryController do
  use Healthlocker.Web, :controller
  alias Healthlocker.Diary

  def new(conn, _params) do
    user_id = conn.assigns.current_user.id
    changeset = Diary.changeset(%Diary{})

    diary_query = from d in Diary, where: d.user_id == ^user_id, order_by: [desc: d.inserted_at]

    case Repo.all(diary_query) do
      [diary | _] ->
        case NaiveDateTime.to_date(diary.inserted_at) == Date.utc_today() do
          true ->
            conn
            |> redirect(to: diary_path(conn, :edit, diary))
          _ ->
            render conn, "new.html", changeset: changeset
        end
      _ ->
        render conn, "new.html", changeset: changeset
    end
  end

  def create(conn, %{"diary" => diary}) do
    changeset =
      conn.assigns.current_user
      |> build_assoc(:diaries)
      |> Diary.changeset(diary)

    case Repo.insert(changeset) do
      {:ok, _entry} ->
        conn
        |> put_flash(:info, "Diary saved successfully!")
        |> redirect(to: toolkit_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id" => diary_id}) do
    diary = Repo.get(Diary, diary_id)
    changeset = Diary.changeset(diary)
    render conn, "edit.html", changeset: changeset, diary: diary
  end

  def update(conn, %{"id" => diary_id, "diary" => diary}) do
    old_diary = Repo.get(Diary, diary_id)
    changeset = Diary.changeset(old_diary, diary)

    case Repo.update(changeset) do
      {:ok, _entry} ->
        conn
        |> put_flash(:info, "Updated diary diary diary entry")
        |> redirect(to: toolkit_path(conn, :index))
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, diary: old_diary
    end
  end
end
