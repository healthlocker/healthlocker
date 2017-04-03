defmodule Healthlocker.SleepTrackerView do
  use Healthlocker.Web, :view
  use Timex

  defp get_past_week(data, end_date) do
    Enum.filter(data, fn struct ->
      Date.compare(struct.for_date, end_date) != :gt
      and
      Date.compare(struct.for_date, last_week(end_date)) != :lt
    end)
  end

  defp last_week(end_date) do
    Timex.shift(end_date, days: -7)
  end

  def get_week_average(data, from_date) do
    {:ok, date} = Date.from_iso8601(from_date)
    past_week = get_past_week(data, date)
    total_slept = Enum.map(past_week, fn struct -> String.to_float(struct.hours_slept) end)
      |> Enum.reduce(0, fn(x, acc) -> x + acc end)
    total_slept / Kernel.length(past_week)
  end

  def format_sleep_data(data, from_date) do
    {:ok, date} = Date.from_iso8601(from_date)
    week_data = get_past_week(data, date)
    format_hours_list(week_data, [], 1)
    |> Enum.join(",")
  end

  defp format_hours_list(data, list, 7) do
    # add hours to front of list
    new_list = if Enum.any?(data, fn(struct) ->
                Date.day_of_week(struct.for_date) == 7
              end) do
                List.insert_at(
                  list,
                  0,
                  Enum.at(Enum.filter(data, fn struct ->
                    Date.day_of_week(struct.for_date) == 7
                  end), 0).hours_slept
                )
              else
                List.insert_at(list, 0, 0)
              end
  end

  defp format_hours_list(data, list, n) do
    # add hours_slept to list if day == n, else add 0.
    new_list = if Enum.any?(data, fn(struct) ->
                  Date.day_of_week(struct.for_date) == n
                end) do
                  List.insert_at(
                    list,
                    n - 1,
                    Enum.at(Enum.filter(data, fn struct ->
                      Date.day_of_week(struct.for_date) == n
                    end), 0).hours_slept
                  )
                else
                  List.insert_at(list, n - 1, 0)
                end
    format_hours_list(data, new_list, n + 1)
  end
end
