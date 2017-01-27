defmodule Healthlocker.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :dob, :date
      add :email, :string
      add :password, :string
      add :pin, :string
      add :security_question, :string
      add :security_answer, :string

      timestamps()
    end

  end
end
