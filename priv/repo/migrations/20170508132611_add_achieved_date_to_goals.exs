defmodule Healthlocker.Repo.Migrations.AddAchievedDateToGoals do
  use Ecto.Migration

  def change do
    alter table(:goals) do
      add :achieved_at, :date
    end
  end
end
