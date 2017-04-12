defmodule Healthlocker.Repo.Migrations.AddDetailsToGoals do
  use Ecto.Migration

  def change do
    alter table(:goals) do
      add :details, :map
    end
  end
end
