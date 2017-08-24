defmodule Healthlocker.ReadOnlyRepo.Migrations.AddSummaryNeeds do
  use Ecto.Migration

  def change do
    create table(:mhlSummaryOfNeed, primary_key: false) do
      add :Patient_ID, :integer
      add :Assessed_By, :text
      add :Assessed_Date, :utc_datetime
      add :End_Date, :utc_datetime
      add :Summary_Of_Need_Mental_Health, :text
      add :Summary_Of_Need_Physical_Health, :text
      add :Summary_Of_Need_Relationship, :text
      add :Summary_Of_Need_Occupation_Education, :text
      add :Summary_Of_Need_Daily_Living, :text
      add :Summary_Of_Need_Accomodation, :text
      add :Summary_Of_Need_Finance, :text
      add :Summary_Of_Need_Ethnicity, :text
      add :Summary_Of_Need_Drug, :text
      add :Summary_Of_Need_Religion, :text
      add :Summary_Of_Need_Child_need, :text
      add :Summary_Of_Need_Risk, :text
    end
  end
end
