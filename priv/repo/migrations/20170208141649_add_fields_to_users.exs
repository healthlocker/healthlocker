defmodule Healthlocker.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
      add :security_question, :string
      add :security_answer, :string
      add :data_access, :boolean
      add :role, :string
    end
  end
end
