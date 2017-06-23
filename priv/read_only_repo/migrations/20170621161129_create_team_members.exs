defmodule Healthlocker.ReadOnlyRepo.Migrations.CreateTeamMembers do
  use Ecto.Migration

  def change do
    create table(:mhlTeamMembers, primary_key: false) do
      add :Patient_ID, :integer
      add :Staff_ID, :integer
      add :Staff_Name, :string
      add :Job_Title, :string
      add :Team_Member_Role_Desc, :string
      add :Email, :string
    end
  end
end
