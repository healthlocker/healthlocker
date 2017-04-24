defmodule Healthlocker.Repo.Migrations.AddSlamId do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :slam_id, :integer
    end
  end
end
