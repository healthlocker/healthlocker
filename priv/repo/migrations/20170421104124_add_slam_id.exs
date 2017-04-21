defmodule Healthlocker.Repo.Migrations.AddSlamId do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :slam_user
      add :slam_id, :integer
    end
  end
end
