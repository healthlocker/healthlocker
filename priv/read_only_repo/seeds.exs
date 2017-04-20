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

alias Healthlocker.{ReadOnlyRepo, EPJSUser}

defmodule Healthlocker.EPJSSeeder do
  def add_epjs_users(200) do
    {:ok, dob_datetime} = DateTime.from_naive(~N[1988-05-24 13:26:08.003], "Etc/UTC")
    {:ok, start_datetime} = DateTime.from_naive(~N[2008-08-16 13:26:08.003], "Etc/UTC")
    ReadOnlyRepo.insert!(%EPJSUser{
      patient_id: 200,
      surname: Faker.Name.last_name(),
      forename: Faker.Name.first_name(),
      title: Faker.Name.title(),
      patient_name: Faker.Name.name(),
      trust_id: to_string(Faker.Lorem.characters(10)),
      nhs_number: to_string(Faker.Lorem.characters(20)),
      dob: dob_datetime,
      spell_number: Enum.random(1..5),
      spell_start_date: start_datetime,
      spell_end_date: nil
      })
  end

  def add_epjs_users(n) do
    {:ok, dob_datetime} = DateTime.from_naive(~N[1988-05-24 13:26:08.003], "Etc/UTC")
    {:ok, start_datetime} = DateTime.from_naive(~N[2008-08-16 13:26:08.003], "Etc/UTC")
    ReadOnlyRepo.insert!(%EPJSUser{
      patient_id: n,
      surname: Faker.Name.last_name(),
      forename: Faker.Name.first_name(),
      title: Faker.Name.title(),
      patient_name: Faker.Name.name(),
      trust_id: to_string(Faker.Lorem.characters(10)),
      nhs_number: to_string(Faker.Lorem.characters(20)),
      dob: dob_datetime,
      spell_number: Enum.random(1..5),
      spell_start_date: start_datetime,
      spell_end_date: nil
      })

    add_epjs_users(n + 1)
  end
end

{:ok, dob1} = DateTime.from_naive(~N[1988-05-24 13:26:08.003], "Etc/UTC")
{:ok, dob2} = DateTime.from_naive(~N[1975-01-14 13:26:08.003], "Etc/UTC")
{:ok, dob3} = DateTime.from_naive(~N[1997-07-01 13:26:08.003], "Etc/UTC")

{:ok, start1} = DateTime.from_naive(~N[2016-05-24 13:26:08.003], "Etc/UTC")
{:ok, start2} = DateTime.from_naive(~N[1997-01-14 13:26:08.003], "Etc/UTC")
{:ok, start3} = DateTime.from_naive(~N[2011-07-01 13:26:08.003], "Etc/UTC")

ReadOnlyRepo.insert!(%EPJSUser{
  patient_id: 201,
  surname: "Hernandez",
  forename: "Angela",
  title: "Ms.",
  patient_name: "Angela Hernandez",
  trust_id: "fYXSryfK7N",
  nhs_number: "LbweJ2oXsNl14ayv37d7",
  dob: dob1,
  spell_number: 2,
  spell_start_date: start1,
  spell_end_date: nil
  })

ReadOnlyRepo.insert!(%EPJSUser{
  patient_id: 202,
  surname: "Burns",
  forename: "Evan",
  title: "Mr.",
  patient_name: "Evan Burns",
  trust_id: "uG0lDAx0S8",
  nhs_number: "gLiyI9gsgoHjQc6pMcaT",
  dob: dob2,
  spell_number: 3,
  spell_start_date: start2,
  spell_end_date: nil
  })

ReadOnlyRepo.insert!(%EPJSUser{
  patient_id: 203,
  surname: "Sandoval",
  forename: "Lisa",
  title: "Mrs.",
  patient_name: "Lisa Sandoval",
  trust_id: "cJY6pckGwh",
  nhs_number: "E8zCRgZ4ByGzKqCMnBKD",
  dob: dob3,
  spell_number: 1,
  spell_start_date: start3,
  spell_end_date: nil
  })

Healthlocker.EPJSSeeder.add_epjs_users(1)
