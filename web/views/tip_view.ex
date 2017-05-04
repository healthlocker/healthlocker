defmodule Healthlocker.TipView do
  use Healthlocker.Web, :view
  import Healthlocker.ComponentView, only: [markdown: 1]

  @tips ["Connect", "KeepLearning", "GiveToOthers", "BeActive", "TakeNotice"]
  @descriptions %{
    Connect: " with the people around us. Building stronger, wider social
      connections can help us feel happier and more secure, and give us a
      greater sense of purpose.",
    BeActive: "There’s an activity out there for all of us, suited to our level
      of fitness and mobility. Being active is great for our physical health
      and fitness, and also improves our mental wellbeing. Evidence shows moods
      can improve after just 10 minutes of exercise. Even just walking more
      every day can make a big difference.",
    KeepLearning: "Learning can boost self-confidence and self-esteem, help
      build a sense of purpose, and help us connect with others. Research shows
      that learning throughout life is associated with greater satisfaction and
      optimism, and improved ability to get the most from life.",
    GiveToOthers: "Doing even little things for others can give us a sense of
      purpose and self-worth. It can make us feel happier and more satisfied with
      life. Being kind to others can stimulate the reward areas in our brain,
      creating positive feelings. Even doing something small for someone else can
      give us a buzz.",
    TakeNotice: "Being in the moment, including just being aware of our
      thoughts, feelings, body and the world around us, can help us appreciate the little things, understand ourselves more and get the most out of being alive."
  }
  @questions %{
    Connect: "Who might you want to connect more with?",
    BeActive: "How might you get more active in your daily life?",
    KeepLearning: "What might you want to learn more about?",
    GiveToOthers: "How might you do something kind for someone today?",
    TakeNotice: "When in your day can you stop to notice what’s happening with you and around you?"
  }

  def get_category(content_string) do
    @tips
    |> Enum.filter(fn type -> String.contains?(content_string, type) end)
    |> List.first
  end

  def category_description(url) do
    category = get_category(url)
    Map.get(@descriptions, String.to_atom(category))
  end

  def category_question(url) do
    category = get_category(url)
    Map.get(@questions, String.to_atom(category))
  end
end
