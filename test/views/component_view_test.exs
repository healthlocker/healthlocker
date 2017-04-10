defmodule Healthlocker.AccountViewTest do
  use Healthlocker.ConnCase, async: true
  alias Healthlocker.ComponentView

  test "get_options returns a list of questions" do
    actual = ComponentView.get_options("security_questions")
    expected = ["Favourite teacher's name?", "First pet's name?",
    "Town you were born in?", "Name of primary school?",
    "Name of your first boss?"]
    assert actual == expected
  end

  test "get_options returns a list of hours" do
    actual = ComponentView.get_options("hours_slept")
    expected = Enum.to_list(0..48)
              |> Enum.map(&(&1/2))
              |> Enum.map(fn num -> if num == 0.0 do
                  "0"
                else
                  Float.to_string(num)
                end
              end)
    assert actual == expected
  end

  test "get_options returns a list of wake counts" do
    actual = ComponentView.get_options("wake_count")
    expected = Enum.to_list(0..10)
              |> Enum.map(fn num -> if num == 10 do
                  "10+"
                else
                  Integer.to_string(num)
                end
              end)
    assert actual == expected
  end

  test "pretty_date returns date in the format DD/MM/YYYY" do
    {:ok, date} = Date.new(2017, 4, 10)
    actual =  ComponentView.pretty_date(date)
    expected = "10/04/2017"
    assert actual == expected
  end

  test "markdown converts markdown to html" do
    actual = ComponentView.markdown("**tip title**\n\ntip body\n\n#Tip #Connect")
    expected = {:safe,
    "<p><strong>tip title</strong></p>\n<p>tip body</p>\n<p>#<a href=\"/tips?tag=Tip\">Tip</a> #<a href=\"/tips?tag=Connect\">Connect</a></p>\n"}
    assert actual == expected
  end
end
