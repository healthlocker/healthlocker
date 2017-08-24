defmodule Healthlocker.EPJSRcpHelpFromOthers do
  use Healthlocker.Web, :model

  @primary_key {:SLAM_Recovery_Focused_Care_Plan_ID, :integer, autogenerate: false}
  schema "mhlSLAMRecoveryFocusedCarePlanGettingHelpFromOthersGeneral" do
    field :Others_Might_Do_Detail, :string
    field :Supporters_Action_To_Take_Detail, :string
    field :Previous_Support_Type_Detail, :string
  end
end
