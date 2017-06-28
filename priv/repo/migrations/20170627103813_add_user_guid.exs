defmodule Healthlocker.Repo.Migrations.AddUserGuid do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :user_guid, :string
    end
  end
end
