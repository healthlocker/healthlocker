defmodule Healthlocker.Repo.Migrations.AddDateForToSleepTracker do
  use Ecto.Migration

  def change do
    alter table(:sleep_trackers) do
      add :for_date, :date, null: false
    end
  end
end
