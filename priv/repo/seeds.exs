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
      role: "slam_user",
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
  end

  def add_many_stories(n, number_of_users) do
    Repo.insert!(%Post{
      content: "# " <> Faker.Lorem.sentence(6) <> "\n" <> Enum.join(Faker.Lorem.paragraphs(12), "\n") <> "\n" <> "#story",
      user_id: 1
    })
    add_many_stories(n - 1, number_of_users)
  end

  def add_many_tips(n, number_of_users) when n <= 1 do
    Repo.insert!(%Post{
      content: "**" <> Faker.Lorem.sentence(8) <> "** \n" <> Faker.Lorem.paragraph(2) <> "\n #Tip " <> Enum.random(["#Connect", "#BeActive", "#KeepLearning", "#TakeNotice", "#GiveToOthers"]),
      user_id: 1
    })
  end

  def add_many_tips(n, number_of_users) do
    Repo.insert!(%Post{
      content: "**" <> Faker.Lorem.sentence(8) <> "** \n" <> Faker.Lorem.paragraph(2) <> "\n #Tip " <> Enum.random(["#Connect", "#BeActive", "#KeepLearning", "#TakeNotice", "#GiveToOthers"]),
      user_id: 1
    })
    add_many_tips(n - 1, number_of_users)
  end

  def add_user_content(user_id) do
    Repo.insert!(%Post{
      content: Faker.Lorem.sentence(10) <> " #CopingStrategy",
      user_id: user_id
    })

    Repo.insert!(%Goal{
      content: Faker.Lorem.sentence(10) <> " #Goal",
      completed: Enum.random([true, false]),
      notes: Faker.Lorem.paragraph(3),
      important: Enum.random([true, false]),
      user_id: user_id
    })
  end
end
