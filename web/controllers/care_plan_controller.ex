defmodule Healthlocker.CarePlanController do
  use Healthlocker.Web, :controller
  alias Healthlocker.{EPJSSummaryNeeds, EPJSRecoveryCarePlan,
  EPJSRcpLifeEventTriggers, EPJSRcpHelpFromOthers, EPJSRcpGoalsAsp,
  EPJSRcpDailyActivity, EPJSRcpContingency}

  def index(conn, _params) do
    id = conn.assigns.current_user.slam_id
    care_plan_data = get_care_plan_data(id)
    conn
    |> render("index.html", summary_needs: care_plan_data.summary_needs,
    recovery_care_plan: care_plan_data.recovery_care_plan,
    life_event_triggers: care_plan_data.life_event_triggers,
    help_from_others: care_plan_data.help_from_others,
    goals_asp: care_plan_data.goals_asp,
    daily_activity: care_plan_data.daily_activity,
    contingency: care_plan_data.contingency)
  end

  def get_care_plan_data(patient_id) do
    summary_needs_query = from esn in EPJSSummaryNeeds,
            where: esn."Patient_ID" == ^patient_id
    summary_needs =  ReadOnlyRepo.one(summary_needs_query)

    recovery_care_plan_query = from esn in EPJSRecoveryCarePlan,
                               where: esn."Patient_ID" == ^patient_id
    recovery_care_plan = ReadOnlyRepo.one(recovery_care_plan_query)

    life_event_triggers =
      if recovery_care_plan do
        query = from esn in EPJSRcpLifeEventTriggers,
        where: esn."SLAM_Recovery_Focused_Care_Plan_ID" == ^recovery_care_plan."SLAM_Recovery_Focused_Care_Plan_ID"
        ReadOnlyRepo.all(query)
      else
        nil
      end

    help_from_others =
      if recovery_care_plan do
        query = from esn in EPJSRcpHelpFromOthers,
        where: esn."SLAM_Recovery_Focused_Care_Plan_ID" == ^recovery_care_plan."SLAM_Recovery_Focused_Care_Plan_ID"
        ReadOnlyRepo.all(query)
      else
        nil
      end

      goals_asp =
        if recovery_care_plan do
          query = from esn in EPJSRcpGoalsAsp,
          where: esn."SLAM_Recovery_Focused_Care_Plan_ID" == ^recovery_care_plan."SLAM_Recovery_Focused_Care_Plan_ID"
          ReadOnlyRepo.all(query)
        else
          nil
        end

      daily_activity =
        if recovery_care_plan do
          query = from esn in EPJSRcpDailyActivity,
          where: esn."SLAM_Recovery_Focused_Care_Plan_ID" == ^recovery_care_plan."SLAM_Recovery_Focused_Care_Plan_ID"
          ReadOnlyRepo.all(query)
        else
          nil
        end

      contingency =
        if recovery_care_plan do
          query = from esn in EPJSRcpContingency,
          where: esn."SLAM_Recovery_Focused_Care_Plan_ID" == ^recovery_care_plan."SLAM_Recovery_Focused_Care_Plan_ID"
          ReadOnlyRepo.all(query)
        else
          nil
        end



    %{summary_needs: summary_needs, recovery_care_plan: recovery_care_plan,
    life_event_triggers: life_event_triggers, help_from_others: help_from_others,
    goals_asp: goals_asp, daily_activity: daily_activity,
    contingency: contingency}
  end
end
