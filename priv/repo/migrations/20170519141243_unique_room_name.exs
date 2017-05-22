defmodule Healthlocker.Repo.Migrations.UniqueRoomName do
  use Ecto.Migration

  def change do
    create unique_index(:rooms, [:name])
  end
end
