defmodule Healthlocker.EPJSRecoveryCarePlan do
  use Healthlocker.Web, :model

  @primary_key {:SLAM_Recovery_Focused_Care_Plan_ID, :integer, autogenerate: false}
  schema "mhlSLAMRecoveryCarePlan" do
    field :Patient_ID, :integer
    field :Completed_By, :string
    field :Completed_Date, :utc_datetime
    field :Important_To_Me_Detail, :string
    field :Staying_Well_Detail, :string
    field :Like_To_Be_Different_Detail, :string
    field :Staying_In_Control_Detail, :string
    field :Support_To_Communicate_Detail, :string
    field :Others_Might_Do_Detail, :string
    field :Supporters_Action_To_Take_Detail, :string
    field :Previous_Support_Type_Detail, :string
    field :Preferred_Medication_Detail, :string
    field :Unacceptable_Medication_detail, :string
    field :Prefer_Not_To_Share_With, :string
    field :Feeling_Well_Detail, :string
    field :See_As_My_Strengths_Detail, :string
    field :Recovery_And_Staying_Well_Staff_View, :string
    field :Achieve_Goals_Staff_View, :string
    field :Changes_And_Early_Signs_Staff_View, :string
    field :Life_Events_And_Triggers_Staff_View, :string
    field :Do_In_Crisis_Staff_View, :string
    field :Help_From_Others_Staff_View, :string
    field :Goals_And_Aspirations_Staff_View, :string
  end
end
