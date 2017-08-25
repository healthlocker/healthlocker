defmodule Healthlocker.ReadOnlyRepo.Migrations.AddHelpFromOthers do
  use Ecto.Migration

  def change do
    create table(:mhlSLAMRecoveryFocusedCarePlanGettingHelpFromOthersGeneral, primary_key: false) do
      add :SLAM_Recovery_Focused_Care_Plan_ID, :integer
      add :Supporters_Action_To_Take_Detail, :text
      add :Previous_Support_Type_Detail, :text
    end
  end
end
