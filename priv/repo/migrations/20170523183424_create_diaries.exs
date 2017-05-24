defmodule Healthlocker.Repo.Migrations.CreateDiaries do
  use Ecto.Migration

  def change do
    create table(:diaries) do
      add :entry, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
  end
end
