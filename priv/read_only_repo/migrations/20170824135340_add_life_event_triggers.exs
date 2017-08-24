defmodule Healthlocker.ReadOnlyRepo.Migrations.AddLifeEventTriggers do
  use Ecto.Migration

  def change do
    create table(:mhlSLAMRecoveryFocusedCarePlanLifeEventsTriggers, primary_key: false) do
      add :SLAM_Recovery_Focused_Care_Plan_ID, :integer
      add :Trigger_Detail, :text
      add :Coping_Strategy_Detail, :text
    end
  end
end
