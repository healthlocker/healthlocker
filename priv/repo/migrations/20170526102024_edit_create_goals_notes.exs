defmodule Healthlocker.Repo.Migrations.EditCreateGoalsNotes do
  use Ecto.Migration

  def change do
    alter table(:goals) do
      modify :notes, :text
    end
  end
end
