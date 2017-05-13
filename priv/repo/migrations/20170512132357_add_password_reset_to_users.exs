defmodule Healthlocker.Repo.Migrations.AddPasswordResetToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :reset_password_token, :string
      add :reset_token_sent_at, :utc_datetime
    end
  end
end
