defmodule Healthlocker.Repo.Migrations.AddSlamIdToCarers do
  use Ecto.Migration

  def change do
    drop index(:carers, [:caring_id])
    drop unique_index(:carers, [:caring_id, :carer_id])

    alter table(:carers) do
      modify :caring_id, :integer, null: true
      add :slam_id, :integer, null: false
    end

    create unique_index(:carers, [:carer_id, :slam_id])
  end
end
