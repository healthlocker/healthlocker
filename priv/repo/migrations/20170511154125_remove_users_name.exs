defmodule Healthlocker.Repo.Migrations.RemoveUsersName do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :name
    end
  end
end
