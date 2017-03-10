defmodule Healthlocker.Repo.Migrations.ChangeSlamUserInUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :slam_user
      add :slam, :boolean
    end
  end
end
