defmodule Healthlocker.ReadOnlyRepo.Migrations.AddContingency do
  use Ecto.Migration

  def change do
    create table(:mhlSLAMRecoveryCarePlanContingency, primary_key: false) do
      add :SLAM_Recovery_Focused_Care_Plan_ID, :integer
      add :Changes_Detail, :text
      add :What_Helps_Detail, :text
      add :What_Makes_Worse_Detail, :text
    end
  end
end
