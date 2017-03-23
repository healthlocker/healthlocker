defmodule Healthlocker.Repo.Migrations.CreateSleepTracker do
  use Ecto.Migration

  def change do
    create table(:sleeptrackers) do
      add :hours_slept, :integer
      add :wake_count, :integer
      add :notes, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:sleeptrackers, [:user_id])

  end
end
