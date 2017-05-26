defmodule Healthlocker.Repo.Migrations.EditDiariesTable do
  use Ecto.Migration

  def change do
    alter table(:diaries) do
      modify :entry, :text
    end
  end
end
