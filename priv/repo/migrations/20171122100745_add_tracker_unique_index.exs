defmodule Healthlocker.Repo.Migrations.AddTrackerUniqueIndex do
  use Ecto.Migration

  def change do
    drop index(:symptoms, [:user_id])
    create unique_index(:symptoms, [:user_id])
  end
end
