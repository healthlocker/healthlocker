alias Healthlocker.{Repo, User, SleepTracker}

defmodule Healthlocker.SleepSeeder do
  @hours [
    "0", "0.5", "1.0", "1.5", "2.0", "2.5", "3.0", "3.5", "4.0", "4.5", "5.0",
    "5.5", "6.0", "6.5", "7.0", "7.5", "8.0", "8.5", "9.0", "9.5", "10.0",
    "10.5", "11.0", "11.5", "12.0", "12.5", "13.0", "13.5", "14.0"
  ]
  @wake ["0", "1", "2", "3", "4", "5", "6", "7", "9", "10+"]
  @notes ["Too hot", "Bad dreams", "Too cold", "Drank too much",
            "Very thirsty", "Nightmares", ""]

  def add_sleep_data(27, id) do
    {:ok, date} = Date.new(2017, 4, 27)
    Repo.insert!(%SleepTracker{
      hours_slept: Enum.random(@hours),
      wake_count: Enum.random(@wake),
      notes: Enum.random(@notes),
      for_date: date,
      user_id: id
    })
  end

  def add_sleep_data(day, id) do
    {:ok, date} = Date.new(2017, 4, day)
    Repo.insert!(%SleepTracker{
      hours_slept: Enum.random(@hours),
      wake_count: Enum.random(@wake),
      notes: Enum.random(@notes),
      for_date: date,
      user_id: id,
    })

    add_sleep_data(day + 1, id)
  end
end

evan = User
      |> Repo.get_by(email: "evan@email.com")

{:ok, date6} = Date.new(2017, 4, 6)
Repo.insert!(%SleepTracker{
  hours_slept: "9.0",
  wake_count: "2",
  notes: "Good sleep!",
  for_date: date6,
  user_id: evan.id
})

{:ok, date7} = Date.new(2017, 4, 7)
Repo.insert!(%SleepTracker{
  hours_slept: "6.5",
  wake_count: "5",
  notes: "Drank too much night before, kept waking up",
  for_date: date7,
  user_id: evan.id
})

{:ok, date9} = Date.new(2017, 4, 9)
Repo.insert!(%SleepTracker{
  hours_slept: "7.0",
  wake_count: "0",
  notes: "",
  for_date: date9,
  user_id: evan.id
})

{:ok, date10} = Date.new(2017, 4, 10)
Repo.insert!(%SleepTracker{
  hours_slept: "7.5",
  wake_count: "1",
  notes: "Took a while to fall asleep",
  for_date: date10,
  user_id: evan.id
})

{:ok, date13} = Date.new(2017, 4, 13)
Repo.insert!(%SleepTracker{
  hours_slept: "8.5",
  wake_count: "3",
  notes: "Needed to get up for some water",
  for_date: date13,
  user_id: evan.id
})

{:ok, date15} = Date.new(2017, 4, 15)
Repo.insert!(%SleepTracker{
  hours_slept: "6.5",
  wake_count: "0",
  notes: "Still felt tired when I woke up",
  for_date: date15,
  user_id: evan.id
})

Healthlocker.SleepSeeder.add_sleep_data(18, evan.id)
