defmodule Healthlocker.Repo.Migrations.CreateSlamUser do
  use Ecto.Migration

  def change do
    create table(:slam_users) do
     add :first_name, :string
     add :last_name, :string
     add :email, :string
     add :nhs_number, :string
     add :phone_number, :string

     timestamps()
   end
  end
end
