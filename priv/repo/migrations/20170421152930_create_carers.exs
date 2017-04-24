defmodule Healthlocker.Repo.Migrations.CreateCarers do
  use Ecto.Migration

  def change do
    create table(:carers, primary_key: false) do
      add :caring_id, references(:users), null: false
      add :carer_id, references(:users), null: false
    end

    create index(:carers, [:caring_id])
    create index(:carers, [:carer_id])
    create unique_index(:carers, [:caring_id, :carer_id])
  end
end
