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
    expected = "7.0,null,null,null,null,8.0,null"
    assert actual == expected
  end

  test "format_sleep_dates returns a comma separated string of dates" do
    actual = TrackerView.format_sleep_dates("2017-04-10")
    expected = "09/04,10/04,04/04,05/04,06/04,07/04,08/04"
    assert actual == expected
  end

  test "printed_time while in BST" do
    actual = TrackerView.printed_time(~N[2017-09-20 12:22:06.896685])
    expected = "13:22"
    assert actual == expected
  end

  test "printed_time while not in BST" do
    actual = TrackerView.printed_time(~N[2000-01-01 11:00:07])
    expected = "11:00"
    assert actual == expected
  end

  describe "date_with_day_and_month returns the correct date string" do
    test "Monday" do
      actual = TrackerView.date_with_day_and_month(~D[2017-10-16])
      assert actual == "Monday 16 October"
    end

    test "Tuesday" do
      actual = TrackerView.date_with_day_and_month(~D[2017-10-17])
      assert actual == "Tuesday 17 October"
    end

    test "Wednesday" do
      actual = TrackerView.date_with_day_and_month(~D[2017-10-18])
      assert actual == "Wednesday 18 October"
    end

    test "Thursday" do
      actual = TrackerView.date_with_day_and_month(~D[2017-10-19])
      assert actual == "Thursday 19 October"
    end

    test "Friday" do
      actual = TrackerView.date_with_day_and_month(~D[2017-10-20])
      assert actual == "Friday 20 October"
    end

    test "Saturday" do
      actual = TrackerView.date_with_day_and_month(~D[2017-10-21])
      assert actual == "Saturday 21 October"
    end

    test "Sunday" do
      actual = TrackerView.date_with_day_and_month(~D[2017-10-22])
      assert actual == "Sunday 22 October"
    end
  end
end
