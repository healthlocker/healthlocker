defmodule Healthlocker.Repo.Migrations.CreateGoals do
  use Ecto.Migration

  def change do
    create table(:goals) do
      add :content, :string, null: false
      add :completed, :boolean
      add :notes, :string

      timestamps()
    end
  end
end
