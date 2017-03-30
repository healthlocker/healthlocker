# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Healthlocker.Repo.insert!(%Healthlocker.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Faker.start
alias Healthlocker.Repo
alias Healthlocker.User
alias Healthlocker.Post
alias Healthlocker.Goal
alias Healthlocker.Relationship
import Ecto.Query


defmodule Healthlocker.DemoDataSeeder do
  def add_users do
    Repo.insert!(%User{
      email: Faker.Internet.free_email(),
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      name: Faker.Name.first_name(),
      phone_number: Faker.Phone.EnGb.number(),
      security_question: "Name of first boss?",
      security_answer: "Betty",
      data_access: Enum.random([true, false, nil]),
      role: "slam_user"
    })

    query = from u in User,
            order_by: [desc: u.id],
            limit: 1
    user = Repo.one(query)
    add_user_content(user)
    add_stories(user)
    add_tips(user)
  end

  def add_clinicians do
    Repo.insert!(%User{
      email: Faker.Internet.email(),
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      name: Faker.Name.first_name(),
      phone_number: Faker.Phone.EnGb.number(),
      security_question: "Name of first boss?",
      security_answer: "Betty",
      data_access: Enum.random([true, false, nil]),
      role: "clinician"
    })

    query = from u in User,
            order_by: [desc: u.id],
            limit: 1,
            select: u.id
    clinician_id = Repo.one(query)
    add_relationships(clinician_id)
  end

  def add_carers do
    Repo.insert!(%User{
      email: Faker.Internet.free_email(),
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      name: Faker.Name.first_name(),
      phone_number: Faker.Phone.EnGb.number(),
      security_question: "Name of first boss?",
      security_answer: "Betty",
      data_access: Enum.random([true, false, nil]),
      role: "support"
    })

    query = from u in User,
            order_by: [desc: u.id],
            limit: 1,
            select: u.id
    carer_id = Repo.one(query)
    add_relationships(carer_id)
  end

  def add_relationships(user_id) do
    contact_id = Repo.all(from u in User, where: u.role == "slam_user", select: u.id)
              |> Enum.take_random(10)
              |> Enum.each(fn(id) ->
                  Repo.insert!(%Relationship{
                    user_id: user_id,
                    contact_id: id
                  }) end)
  end

  def add_stories(user) do
    Repo.insert!(%Post{
      content: "# " <> Faker.Lorem.sentence(6) <> "\n\n" <> Enum.join(Faker.Lorem.paragraphs(12), "\n") <> "\n\n" <> "#story",
      user_id: user.id
    })
  end

  def add_tips(user) do
    Repo.insert!(%Post{
      content: "**" <> Faker.Lorem.sentence(8) <> "** \n\n" <> Faker.Lorem.paragraph(2) <> "\n\n #Tip " <> Enum.random(["#Connect", "#BeActive", "#KeepLearning", "#TakeNotice", "#GiveToOthers"]),
      user_id: user.id
    })
  end

  def add_user_content(user) do
    Repo.insert!(%Post{
      content: Faker.Lorem.sentence(10) <> " #CopingStrategy",
      user_id: user.id
    })

    Repo.insert!(%Goal{
      content: Faker.Lorem.sentence(10) <> " #Goal",
      completed: Enum.random([true, false]),
      notes: Faker.Lorem.paragraph(3),
      important: Enum.random([true, false]),
      user_id: user.id
    })
  end
end

(1..20) |> Enum.each(fn _ -> Healthlocker.DemoDataSeeder.add_users end)
(1..10) |> Enum.each(fn _ -> Healthlocker.DemoDataSeeder.add_clinicians end)
(1..20) |> Enum.each(fn _ -> Healthlocker.DemoDataSeeder.add_carers end)
