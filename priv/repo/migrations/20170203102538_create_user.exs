defmodule Healthlocker.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :password, :string, virtual: true
      add :password_hash, :string

      timestamps()
    end

  end
end
