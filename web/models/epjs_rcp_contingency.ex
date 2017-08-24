defmodule Healthocker.EPJSRcpContingency do
  use Healthlocker.Web, :model

  @primary_key {:SLAM_Recovery_Focused_Care_Plan_ID, :integer, autogenerate: false}
  schema "mhlSLAMRecoveryCarePlanContingency" do
    field :Changes_Detail, :string
    field :What_Helps_Detail, :string
    field :What_Makes_Worse_Detail, :string
  end
end
