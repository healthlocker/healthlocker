defmodule Healthlocker.Repo.Migrations.EditProblemTrackerNotes do
  use Ecto.Migration

  def change do
    alter table(:symptom_trackers) do
      modify :notes, :text
    end
  end
end
