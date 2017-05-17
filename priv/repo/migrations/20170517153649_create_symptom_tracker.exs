defmodule Healthlocker.Repo.Migrations.CreateSymptomTracker do
  use Ecto.Migration

  def change do
    create table(:symptom_tracker) do
      add :affected_scale, :string
      add :notes, :string
      add :symptom_id, references(:symptoms, on_delete: :delete_all)

      timestamps()
    end
  end
end
