defmodule Healthlocker.Repo.Migrations.AddSlamConnectedToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :slam_user_id, references(:slam_users)
    end
  end
end
