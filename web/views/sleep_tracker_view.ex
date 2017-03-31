defmodule Healthlocker.SleepTrackerView do
  use Healthlocker.Web, :view
  use Timex

  def get_past_week(data, end_date) do
    Enum.filter(data, fn struct ->
      Date.compare(struct.for_date, end_date) != :gt
      and
      Date.compare(struct.for_date, last_week(end_date)) != :lt
    end)
  end

  defp last_week(end_date) do
    Timex.shift(end_date, days: -7)
  end

  def get_week_average(data) do
    total_slept = Enum.map(data, fn struct -> String.to_float(struct.hours_slept) end)
    |> Enum.reduce(0, fn(x, acc) -> x + acc end)
    total_slept / Kernel.length(data)
  end

  def format_sleep_data(data) do
    Enum.map(data, fn struct ->
      "{#{Date.day_of_week(struct.for_date)}: #{struct.hours_slept}}"
    end)
  end
end
