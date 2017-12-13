defmodule Healthlocker.Caseload.UserView do
  use Healthlocker.Web, :view
  import Healthlocker.CopingStrategyView , only: [format_output: 2]

  def format_nhs_number(nhs_number) do
    String.slice(nhs_number, 0, 3) <> " " <> String.slice(nhs_number, 3, 3) <> " " <>
      String.slice(nhs_number, 6, 4)
  end
end
