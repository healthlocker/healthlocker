defmodule Healthlocker.Repo.Migrations.AddFirstLastNameToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :first_name, :string
      add :last_name, :string
    end
  end
end
