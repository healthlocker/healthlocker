defmodule Healthlocker.Caseload.UserView do
  use Healthlocker.Web, :view

  def format_nhs_number(nhs_number) do
    String.slice(nhs_number, 0, 3) <> " " <> String.slice(nhs_number, 3, 3) <> " " <>
      String.slice(nhs_number, 6, 4)
  end

  def user_name(user, nil) do
    user.first_name <> " " <> user.last_name
  end

  def user_name(_user, slam_user) do
    slam_user."Forename" <> " " <> slam_user."Surname"
  end
end
