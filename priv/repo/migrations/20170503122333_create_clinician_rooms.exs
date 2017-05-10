defmodule Healthlocker.Repo.Migrations.CreateClinicianRooms do
  use Ecto.Migration

  def change do
    create table(:clinician_rooms) do
      add :clinician_id, :integer, null: false
      add :room_id, references(:rooms, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:clinician_rooms, [:clinician_id])
    create index(:clinician_rooms, [:room_id])
    create index(:clinician_rooms, [:clinician_id, :room_id], unique: true)
  end
end
