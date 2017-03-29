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


defmodule DemoData do
  def add_multiple_users(n) when n <= 1 do
    Repo.insert!(%User{
      id: n,
      email: Faker.Internet.free_email(),
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      name: Faker.Name.first_name(),
      security_question: "Name of first boss?",
      security_answer: "Betty",
      data_access: Enum.random([true, false, nil])
    })
    add_user_content(n)
  end

  def add_multiple_users(n) do
    Repo.insert!(%User{
      id: n,
      email: Faker.Internet.free_email(),
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      name: Faker.Name.first_name(),
      security_question: "Name of first boss?",
      security_answer: "Betty",
      data_access: Enum.random([true, false, nil])
    })
    add_multiple_users(n - 1)
  end

  def add_many_stories(n, number_of_users) when n <= 1 do
    Repo.insert!(%Post{
      content: "# " <> Faker.Lorem.sentence(5) <> "

      ![alt-tag](" <> Faker.Internet.image_url() <> ")

      " <> Faker.Lorem.paragraphs(12) <> "

       #story",
      user_id: Enum.random([1..number_of_users])
    })
  end

  def add_many_stories(n, number_of_users) do
    Repo.insert!(%Post{
      content: "# " <> Faker.Lorem.sentence(5) <> "

      ![alt-tag](" <> Faker.Internet.image_url() <> ")

      " <> Faker.Lorem.paragraphs(12) <> "

       #story",
      user_id: Enum.random([1..number_of_users])
    })
    add_many_stories(n - 1, number_of_users)
  end

  def add_many_tips(n, number_of_users) when n <= 1 do
    Repo.insert(%Post{
      content: "**" <> Faker.Lorem.sentence(5) <> "**

      " <> Faker.paragraph(2) <> "

       #Tip " <> Enum.random(["#Connect", "#BeActive", "#KeepLearning", "#TakeNotice", "#GiveToOthers"])
    })
  end

  def add_many_tips(n, number_of_users) do
    Repo.insert(%Post{
      content: "**" <> Faker.Lorem.sentence(5) <> "**

      " <> Faker.paragraph(2) <> "

       #Tip " <> Enum.random(["#Connect", "#BeActive", "#KeepLearning", "#TakeNotice", "#GiveToOthers"])
    })
    add_many_tips(n - 1, number_of_users)
  end
end
