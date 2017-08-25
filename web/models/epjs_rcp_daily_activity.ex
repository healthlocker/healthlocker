defmodule Healthlocker.EPJSRcpDailyActivity do
  use Healthlocker.Web, :model

  @primary_key {:SLAM_Recovery_Focused_Care_Plan_ID, :integer, autogenerate: false}
  schema "mhlSLAMRecoveryFocusedCarePlanDailyActivity" do
    field :Activity_Detail, :string
    field :Times_Detail, :string
    field :Activity_Reason_Detail, :string
    field :DailyActAgreeByOther, :string
    field :DailyActAgreeBy, :string
  end
end
