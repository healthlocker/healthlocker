defmodule Healthlocker.Repo.Migrations.CreateTip do
  use Ecto.Migration

  def change do
    create table(:tips) do
      add :value, :string
      add :tag, :string

      timestamps()
    end

  end
end
