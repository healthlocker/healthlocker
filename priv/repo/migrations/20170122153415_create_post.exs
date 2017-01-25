defmodule Healthlocker.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :content, :text , null: false

      timestamps
    end
  end
end
