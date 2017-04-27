defmodule Healthlocker.EPJSClinician do
  use Healthlocker.Web, :model

  schema "epjs_clinicians" do
    field :GP_Code, :string
    field :First_Name, :string
    field :Last_Name, :string
  end

  def changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [:GP_Code, :First_Name, :Last_Name])
  end
end
