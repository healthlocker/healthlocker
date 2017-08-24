defmodule Healthocker.EPJSRcpLifeEventTriggers do
  use Healthlocker.Web, :model

  @primary_key {:SLAM_Recovery_Focused_Care_Plan_ID, :integer, autogenerate: false}
  schema "mhlSLAMRecoveryFocusedCarePlanLifeEventsTriggers" do
    field :Trigger_Detail, :string
    field :Coping_Strategy_Detail, :string
  end
end
