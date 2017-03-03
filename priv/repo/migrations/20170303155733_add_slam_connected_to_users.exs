defmodule Healthlocker.Repo.Migrations.AddSlamConnectedToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :slam_connected, :boolean
    end
  end
end
