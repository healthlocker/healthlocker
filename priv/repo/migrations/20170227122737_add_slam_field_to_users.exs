defmodule Healthlocker.Repo.Migrations.AddSlamFieldToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :slam, :boolean
    end
  end
end
