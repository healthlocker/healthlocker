defmodule Healthocker.EPJSRcpGoalsAsp do
  use Healthlocker.Web, :model

  @primary_key {:SLAM_Recovery_Focused_Care_Plan_ID, :integer, autogenerate: false}
  schema "mhlSLAMRecoveryFocusedCarePlanGoalsAndAsp" do
    field :Personal_Goal_Detail, :string
    field :Required_Action_Detail, :string
    field :Support_By_Detail, :string
  end
end
