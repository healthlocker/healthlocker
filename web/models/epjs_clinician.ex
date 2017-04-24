defmodule Healthlocker.EPJSClinician do
  use Healthlocker.Web, :model

  schema "epjs_clinicians" do
    field :GP_Code, :string
    field :First_Name, :string
    field :Last_Name, :string
  end
end
