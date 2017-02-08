defmodule Healthlocker.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
      add :selected_question, :string
      add :encrypted_answer, :string
      add :data_access, :boolean
      add :role, :string
    end
  end
end
