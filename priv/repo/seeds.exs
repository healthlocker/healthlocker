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
alias Healthlocker.Repo
alias Healthlocker.User

Repo.insert!(%User{
  id: 1000,
  email: "anne@example.com",
  password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
  name: "Anne",
  security_question: "Name of first boss?",
  security_answer: "Martha",
  data_access: false
})

Repo.insert!(%User{
  id: 1001,
  email: "joe@example.com",
  password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
  name: "Joe",
  security_question: "Favourite teacher's name",
  security_answer: "Mr. Cool",
  data_access: true
})

Repo.insert!(%User{
  id: 1003,
  email: "rob@example.com",
  password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
  name: "Rob",
  security_question: "First pet's name?",
  security_answer: "Spot",
  data_access: false
})

Repo.insert!(%User{
  id: 1004,
  email: "kat@example.com",
  password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
  name: "Kat",
  security_question: "First pet's name?",
  security_answer: "Fluffy",
  data_access: false
})

Repo.insert!(%User{
  id: 1005,
  email: "nelson@example.com",
  password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
  name: "Nelson",
  security_question: "Town you were born in?",
  security_answer: "London",
  data_access: true
})
