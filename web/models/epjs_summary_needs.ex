defmodule Healthocker.EPJSSummaryNeeds do
  use Healthlocker.Web, :model

  @primary_key {:Patient_ID, :integer, autogenerate: false}
  schema "mhlSummaryOfNeed" do
    field :Assessed_By, :string
    field :Assessed_Date, :utc_datetime
    field :End_Date, :utc_datetime
    field :Summary_Of_Need_Mental_Health, :string
    field :Summary_Of_Need_Physical_Health, :string
    field :Summary_Of_Need_Relationship, :string
    field :Summary_Of_Need_Occupation_Education, :string
    field :Summary_Of_Need_Daily_Living, :string
    field :Summary_Of_Need_Accomodation, :string
    field :Summary_Of_Need_Finance, :string
    field :Summary_Of_Need_Ethnicity, :string
    field :Summary_Of_Need_Drug, :string
    field :Summary_Of_Need_Religion, :string
    field :Summary_Of_Need_Child_need, :string
    field :Summary_Of_Need_Risk, :string
  end
end
