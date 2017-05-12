defmodule Healthlocker.Repo.Migrations.CreateReadReceipt do
  use Ecto.Migration

  def change do
    create table(:read_receipts) do
      add :message_id, references(:messages, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:read_receipts, [:message_id], unique: true)
    create index(:read_receipts, [:user_id])
  end
end
