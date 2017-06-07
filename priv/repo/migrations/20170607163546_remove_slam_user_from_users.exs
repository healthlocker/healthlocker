defmodule Healthlocker.Repo.Migrations.RemoveSlamUserFromUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :slam_user
    end
  end
end
