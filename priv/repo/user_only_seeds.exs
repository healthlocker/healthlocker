alias Healthlocker.{Repo, User}

Repo.insert!(%User{
  email: "evan@email.com",
  password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
  first_name: "Evan",
  last_name: "Email",
  phone_number: "07512 345 678",
  security_question: "Name of first boss?",
  security_answer: "Betty",
  data_access: true,
  role: "slam_user"
})

Repo.insert!(%User{
  email: "lisa@email.com",
  password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
  first_name: "Lisa",
  last_name: "Email",
  phone_number: "07512 678 345",
  security_question: "Name of first boss?",
  security_answer: "Betty",
  data_access: false,
  role: "slam_user"
})

Repo.insert!(%User{
  email: "angela@email.com",
  password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
  first_name: "Angela",
  last_name: "Email",
  phone_number: "07519 283 475",
  security_question: "Name of first boss?",
  security_answer: "Betty",
  data_access: false,
  role: "slam_user"
})
