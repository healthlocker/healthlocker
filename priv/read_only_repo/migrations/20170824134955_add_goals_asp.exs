defmodule Healthlocker.ReadOnlyRepo.Migrations.AddGoalsAsp do
  use Ecto.Migration

  def change do
    create table(:mhlSLAMRecoveryFocusedCarePlanGoalsAndAsp, primary_key: false) do
      add :SLAM_Recovery_Focused_Care_Plan_ID, :integer
      add :Personal_Goal_Detail, :text
      add :Required_Action_Detail, :text
      add :Support_By_Detail, :text
    end
  end
end
