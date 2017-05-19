defmodule Healthlocker.Repo.Migrations.CreateSymptom do
  use Ecto.Migration

  def change do
    create table(:symptoms) do
      add :symptom, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
    create index(:symptoms, [:user_id])
  end
end
