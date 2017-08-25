defmodule Healthlocker.ReadOnlyRepo.Migrations.AddRecoveryCarePlan do
  use Ecto.Migration

  def change do
    create table(:mhlSLAMRecoveryCarePlan, primary_key: false) do
      add :SLAM_Recovery_Focused_Care_Plan_ID, :integer
      add :Patient_ID, :integer
      add :Completed_By, :text
      add :Completed_Date, :utc_datetime
      add :Important_To_Me_Detail, :text
      add :Staying_Well_Detail, :text
      add :Like_To_Be_Different_Detail, :text
      add :Staying_In_Control_Detail, :text
      add :Support_To_Communicate_Detail, :text
      add :Others_Might_Do_Detail, :text
      add :Supporters_Action_To_Take_Detail, :text
      add :Previous_Support_Type_Detail, :text
      add :Preferred_Medication_Detail, :text
      add :Unacceptable_Medication_detail, :text
      add :Prefer_Not_To_Share_With, :text
      add :Feeling_Well_Detail, :text
      add :See_As_My_Strengths_Detail, :text
      add :Recovery_And_Staying_Well_Staff_View, :text
      add :Achieve_Goals_Staff_View, :text
      add :Changes_And_Early_Signs_Staff_View, :text
      add :Life_Events_And_Triggers_Staff_View, :text
      add :Do_In_Crisis_Staff_View, :text
      add :Help_From_Others_Staff_View, :text
      add :Goals_And_Aspirations_Staff_View, :text
    end
  end
end
