defmodule Healthlocker.Repo.Migrations.CreateAddress do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :flat_number, :integer
      add :building_name, :string
      add :street_name, :string
      add :city, :string
    end
  end
end
