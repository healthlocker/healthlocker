defmodule Healthlocker.CarePlanQuery do
  import Ecto.Query

  def get_care_plan_details(struct, care_plan_id) do
    from cp in struct,
    where: cp."SLAM_Recovery_Focused_Care_Plan_ID" == ^care_plan_id
  end
end
