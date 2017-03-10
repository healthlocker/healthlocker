defmodule Healthlocker.Repo.Migrations.AddDobToSlamUsers do
  use Ecto.Migration

  def change do
    alter table(:slam_users) do
      add :date_of_birth, :string
    end
  end
end
