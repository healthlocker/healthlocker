defmodule Healthlocker.Repo.Migrations.AddSlamFieldToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :slam_user, :boolean
    end
  end
end
