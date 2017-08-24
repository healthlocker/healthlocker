defmodule Healthlocker.ReadOnlyRepo.Migrations.AddDailyActivity do
  use Ecto.Migration

  def change do
    create table(:mhlSLAMRecoveryFocusedCarePlanDailyActivity, primary_key: false) do
      add :SLAM_Recovery_Focused_Care_Plan_ID, :integer
      add :Activity_Detail, :text
      add :Times_Detail, :text
      add :Activity_Reason_Detail, :text
      add :DailyActAgreeByOther, :text
      add :DailyActAgreeBy, :text
    end
  end
end
