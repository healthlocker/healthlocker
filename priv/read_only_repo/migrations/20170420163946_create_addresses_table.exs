defmodule Healthlocker.ReadOnlyRepo.Migrations.CreateAddressesTable do
  use Ecto.Migration

  def change do
    create table(:epjs_patient_address_details) do
      add :Patient_ID, :integer, null: false
      add :Address_ID, :integer, null: false
      add :Address1, :string
      add :Address2, :string
      add :Address3, :string
      add :Address4, :string
      add :Address5, :string
      add :Post_Code, :string
      add :Tel_home, :string
      add :Tel_Mobile, :string
      add :Tel_Work, :string
      add :Email_Address, :string
    end
  end
end
