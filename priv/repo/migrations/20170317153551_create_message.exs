defmodule Healthlocker.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:messages, [:user_id])

  end
end
