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
alias Healthlocker.Post

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

Repo.insert!(%Post{
  content: "# Gaining strength from relationships to talk about depression

  ![alt tag](https://www.mentalhealth.org.uk/sites/default/files/Lukes.jpg)

  In a time where many of us get a glimpse into each others lives via social media, it may be easy to assume someone’s life looks not only amazing, but they are extremely happy.

   As I have experienced myself, it can take many years before someone feels able to speak openly about depression, and the daily struggles that go with it.

  I feel fortunate to have grown up in a loving family, and with all the essentials needed to live a healthy life, as many in this world do not. But, on a daily basis the negative, destructive voices that project loudly between my ears are a constant.

  As an endurance adventurer, my life online, and in the flesh, may look and sound amazingly perfect to many. But after suffering in silence for nearly a decade, it’s only been over the past 12 months that I have felt the courage and strength to speak openly about the darker side of my life, and the battle I constantly have with depression.

  **Summoning the strength**

  What has triggered this newfound strength? I mainly put it down to the constant relationships I have had with many friends and family members over the years. It’s been within these relationships where I’ve felt most comfortable, and after years of hiding my experiences away, the strength I have today from these relationships has enabled me to speak openly about what I go through.

  One particular friendship has been quite unique, and helped me not only get through some difficult times, but has also encouraged me to enjoy life as well. Darrell and I have been mates for years now, he is someone who I’ve spent plenty of time laughing, joking, and chatting with.

  There were several moments over the past few years when I was having some extremely dark thoughts, and although I never spoke specifically about the battles I was having, Darrell was simply around to listen, and chat when I needed. He knew me well, and would make me laugh easily as we share a very similar sense of humour, but at the same time, he’d know when it wasn’t time to joke, and would just listen.

  Darrell was simply there for me, not 24/7, or every day even, but I knew that if I did need him, I could call to just chat about life, laugh at our own jokes, or enjoy a coffee together in each other’s presence. Knowing I had Darrell in my corner made me feel like I was needed on this planet.

  Although I never opened up to him about my ongoing battle with depression for years, having someone to simply speak with about anything but the destructive conversations that were constantly going on in my head, was paramount to helping me eventually tell him, and others about what I have been experiencing.

  **Stay connected**

  My journey is far from over, but I would urge anyone who is suffering in silence to simply regularly meet up and chat with a close friend, or another human being, as having a connection with someone (from my experience) can go along way to helping anyone feel supported.

  It doesn’t matter what it’s about, but just start a conversation with a person you have a relationship with, and you may begin to smile on the inside, as well as the outside.

  ### By Luke

  [Link to original](https://www.mentalhealth.org.uk/stories/gaining-strength-relationships-talk-about-depression)

  #story",
  user_id: 1000
})

Repo.insert!(%Post{
  content: "**Where possible try to remove distractions from your bedroom.**

  It is better to watch TV, play computer games and eat in another room. This will allow you to relax with no distractions in your bedroom.

  #Tip #TakeNotice",
  user_id: 1001
})

Repo.insert!(%Post{
  content: "**If things are getting too much for you and you feel you can’t cope, ask for help.**

  We all sometimes get tired or overwhelmed by how we feel or when things don’t go to plan.

  #Tip #Connect",
  user_id: 1003
})

Repo.insert!(%Post{
  content: "**You could find opportunities to volunteer.**

  Small acts of kindness towards other people can make you feel happier and more fulfilled.

  #Tip #GiveToOthers",
  user_id: 1004
})

Repo.insert!(%Post{
  content: "**Do you think you could try something new today?**

  Maybe taste a new food or travel a new route. These small steps can help you experience the world in a new way.

  #Tip #KeepLearning",
  user_id: 1005
})

Repo.insert!(%Post{
  content: "**Today, how about walking a bit more that you usually would.**

  Evidence shows moods can improve after 10 minutes of exercise.

  #Tip #BeActive",
  user_id: 1000
})
