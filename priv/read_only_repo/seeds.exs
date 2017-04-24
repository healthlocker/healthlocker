# Script for populating the epjs_database. You can run it as:
#
#     mix run priv/read_only_repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Healthlocker.ReadOnlyRepo.insert!(%Healthlocker.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Faker.start

alias Healthlocker.{ReadOnlyRepo, EPJSUser, EPJSClinician, EPJSTeamMember}

defmodule Healthlocker.EPJSSeeder do
  def add_epjs_users(200) do
    dob = DateTime.from_naive!(~N[1988-05-24 13:26:08.003], "Etc/UTC")
    start = DateTime.from_naive!(~N[2008-08-16 13:26:08.003], "Etc/UTC")
    ReadOnlyRepo.insert!(%EPJSUser{
      Patient_ID: 200,
      Surname: Faker.Name.last_name(),
      Forename: Faker.Name.first_name(),
      Title: Faker.Name.title(),
      Patient_Name: Faker.Name.name(),
      Trust_ID: to_string(Faker.Lorem.characters(10)),
      NHS_Number: to_string(Faker.Lorem.characters(20)),
      DOB: dob,
      Spell_Number: Enum.random(1..5),
      Spell_Start_Date: start,
      Spell_End_Date: nil
    })
  end

  def add_epjs_users(n) do
    dob = DateTime.from_naive!(~N[1988-05-24 13:26:08.003], "Etc/UTC")
    start = DateTime.from_naive!(~N[2008-08-16 13:26:08.003], "Etc/UTC")
    ReadOnlyRepo.insert!(%EPJSUser{
      Patient_ID: n,
      Surname: Faker.Name.last_name(),
      Forename: Faker.Name.first_name(),
      Title: Faker.Name.title(),
      Patient_Name: Faker.Name.name(),
      Trust_ID: to_string(Faker.Lorem.characters(10)),
      NHS_Number: to_string(Faker.Lorem.characters(20)),
      DOB: dob,
      Spell_Number: Enum.random(1..5),
      Spell_Start_Date: start,
      Spell_End_Date: nil
    })

    add_epjs_users(n + 1)
  end

  def add_clinicians do
    clinician = ReadOnlyRepo.insert!(%EPJSClinician{
      GP_Code: to_string(Faker.Lorem.characters(16)),
      First_Name: Faker.Name.first_name(),
      Last_Name: Faker.Name.last_name()
    })

    (1..5)
    |> Enum.take_random(20)
    |> add_team_members(clinician.id)
  end

  def add_team_members(patient_list, clinician_id) do
    patient_list
    |> Enum.each(fn patient_id -> ReadOnlyRepo.insert!(%EPJSTeamMember{
      Patient_ID: patient_id,
      Staff_ID: clinician_id
    }) end)
  end
end

{:ok, dob1} = DateTime.from_naive(~N[1988-05-24 13:26:08.003], "Etc/UTC")
{:ok, dob2} = DateTime.from_naive(~N[1975-01-14 13:26:08.003], "Etc/UTC")
{:ok, dob3} = DateTime.from_naive(~N[1997-07-01 13:26:08.003], "Etc/UTC")

{:ok, start1} = DateTime.from_naive(~N[2016-05-24 13:26:08.003], "Etc/UTC")
{:ok, start2} = DateTime.from_naive(~N[1997-01-14 13:26:08.003], "Etc/UTC")
{:ok, start3} = DateTime.from_naive(~N[2011-07-01 13:26:08.003], "Etc/UTC")

ReadOnlyRepo.insert!(%EPJSUser{
  Patient_ID: 201,
  Surname: "Hernandez",
  Forename: "Angela",
  Title: "Ms.",
  Patient_Name: "Angela Hernandez",
  Trust_ID: "fYXSryfK7N",
  NHS_Number: "LbweJ2oXsNl14ayv37d7",
  DOB: dob1,
  Spell_Number: 2,
  Spell_Start_Date: start1,
  Spell_End_Date: nil
})

ReadOnlyRepo.insert!(%EPJSUser{
  Patient_ID: 202,
  Surname: "Burns",
  Forename: "Evan",
  Title: "Mr.",
  Patient_Name: "Evan Burns",
  Trust_ID: "uG0lDAx0S8",
  NHS_Number: "gLiyI9gsgoHjQc6pMcaT",
  DOB: dob2,
  Spell_Number: 3,
  Spell_Start_Date: start2,
  Spell_End_Date: nil
})

ReadOnlyRepo.insert!(%EPJSUser{
  Patient_ID: 203,
  Surname: "Sandoval",
  Forename: "Lisa",
  Title: "Mrs.",
  Patient_Name: "Lisa Sandoval",
  Trust_ID: "cJY6pckGwh",
  NHS_Number: "E8zCRgZ4ByGzKqCMnBKD",
  DOB: dob3,
  Spell_Number: 1,
  Spell_Start_Date: start3,
  Spell_End_Date: nil
})

clinician = ReadOnlyRepo.insert!(%EPJSClinician{
  GP_Code: "NyNsn50mPQPFZYn7",
  First_Name: "Robert",
  Last_Name: "MacMurray"
})

Healthlocker.EPJSSeeder.add_team_members((183..203), clinician.id)
Healthlocker.EPJSSeeder.add_epjs_users(1)
(1..50) |> Enum.each(fn _ -> Healthlocker.EPJSSeeder.add_clinicians() end)
