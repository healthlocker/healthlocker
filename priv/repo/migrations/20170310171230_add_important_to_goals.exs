defmodule Healthlocker.Repo.Migrations.AddImportantToGoals do
  use Ecto.Migration

  def change do
    alter table(:goals) do
      add :important, :boolean
    end
  end
end
