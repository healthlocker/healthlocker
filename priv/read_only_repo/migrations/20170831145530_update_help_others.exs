defmodule Healthlocker.ReadOnlyRepo.Migrations.UpdateHelpOthers do
  use Ecto.Migration

  def change do
    alter table(:mhlSLAMRecoveryFocusedCarePlanGettingHelpFromOthersGeneral) do
      add :Others_Might_Do_Detail, :text
    end
  end
end
