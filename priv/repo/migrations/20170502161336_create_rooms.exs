defmodule Healthlocker.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string, null: false

      timestamps()
    end
  end
end
