defmodule Healthlocker.Repo.Migrations.AddContactConsentToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :comms_consent, :boolean
    end
  end
end
