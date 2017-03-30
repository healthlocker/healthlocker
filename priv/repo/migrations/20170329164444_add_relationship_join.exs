defmodule Healthlocker.Repo.Migrations.AddRelationshipJoin do
  use Ecto.Migration

  def change do
    create table(:relationships) do
      add :user_id, references(:users, on_delete: :delete_all, on_replace: :delete)
      add :contact_id, references(:users, on_delete: :delete_all, on_replace: :delete)
      timestamps()
    end
  end
end
