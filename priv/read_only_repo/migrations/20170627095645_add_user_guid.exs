defmodule Healthlocker.ReadOnlyRepo.Migrations.AddUserGuid do
  use Ecto.Migration

  def change do
    alter table(:mhlTeamMembers) do
      add :User_Guid, :string
    end
  end
end
