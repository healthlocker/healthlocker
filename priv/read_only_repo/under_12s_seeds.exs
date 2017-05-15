alias Healthlocker.{EPJSUser, ReadOnlyRepo}

ReadOnlyRepo.insert!(%EPJSUser{
  Patient_ID: 204,
  Surname: "Power",
  Forename: "Max",
  Title: "Mr.",
  Patient_Name: "Max Power",
  Trust_ID: "fYXSryfK7N",
  NHS_Number: "3351834797",
  DOB: DateTime.from_naive!(~N[2007-01-01 00:00:00.00], "Etc/UTC"),
  Spell_Number: 2,
  Spell_Start_Date: DateTime.from_naive!(~N[2017-01-01 00:00:00.00], "Etc/UTC"),
  Spell_End_Date: nil
})
