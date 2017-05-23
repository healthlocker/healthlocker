defmodule Healthlocker.TrackerViewTest do
  use Healthlocker.ConnCase, async: true
  alias Healthlocker.{TrackerView, SleepTracker}

  doctest TrackerView

  @data [%SleepTracker{
    for_date: ~D[2017-04-07],
    hours_slept: "8.0",
    wake_count: "0"},
   %SleepTracker{
    for_date: ~D[2017-04-09],
    hours_slept: "7.0",
    wake_count: "1"}]

  test "get_week_average returns the correct weekly average" do
    actual = TrackerView.get_week_average(@data)
    expected = "7h 30m"
    assert actual == expected
  end

  test "format_sleep_hours returns a comma separated string of hours" do
    actual = TrackerView.format_sleep_hours(@data)
    expected = "7.0,0,0,0,0,8.0,0"
    assert actual == expected
  end

  test "format_sleep_dates returns a comma separated string of dates" do
    actual = TrackerView.format_sleep_dates("2017-04-10")
    expected = "09/04,10/04,04/04,05/04,06/04,07/04,08/04"
    assert actual == expected
  end

  test "date_with_day_and_month returns the correct date string" do
    actual = TrackerView.date_with_day_and_month(~D[2017-04-07])
    expected = "Friday 7th April"
    assert actual == expected
  end
end
