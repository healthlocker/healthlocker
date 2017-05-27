defmodule Healthlocker.Repo.Migrations.AddC4cToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :c4c, :boolean
    end
  end
end
