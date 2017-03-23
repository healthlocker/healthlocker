defmodule Healthlocker.Repo.Migrations.CreateSleepTracker do
  use Ecto.Migration

  def change do
    create table(:sleep_trackers) do
      add :hours_slept, :string
      add :wake_count, :string
      add :notes, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
    create index(:sleep_trackers, [:user_id])

  end
end
