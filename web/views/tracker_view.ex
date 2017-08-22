defmodule Healthlocker.TrackerView do
  use Healthlocker.Web, :view
  use Timex
  import Healthlocker.PostView, only: [markdown: 1]

  def get_symptom(data) do
    case data do
      [data | _tail] ->
        data.symptom.symptom
      _ ->
        data
    end
  end

  defp last_week(end_date) do
    Timex.shift(end_date, days: -6)
  end

  def get_week_average(data) do
    total_slept = Enum.map(data, fn struct -> String.to_float(struct.hours_slept) end)
      |> Enum.sum
    if Kernel.length(data) == 0 do
      0
    else
      format_average_sleep(total_slept / Kernel.length(data))
    end
  end

  defp hours_mins(humanized_str) do
    humanized_str
      |> String.replace(" hours,", "h")
      |> String.replace(" minutes", "m")
      |> String.split(",")
      |> List.first
  end

  @doc """
    format_average_sleep

  ## Example

      iex> import Healthlocker.TrackerView
      iex> format_average_sleep(7.375)
      "7h 22m"

  """

  def format_average_sleep(num) do
    Duration.from_hours(num)
      |> Timex.Format.Duration.Formatter.format(:humanized)
      |> hours_mins()
  end

  def format_sleep_hours(data) do
    format_hours_list(data, [], 1)
    |> Enum.join(",")
  end

  def format_sleep_dates(end_date) do
    {:ok, date} = Date.from_iso8601(end_date)
    start_date = last_week(date)
    format_dates_list(start_date, [], 1)
    |> Enum.join(",")
  end

  def format_symptom_scale(symptom_data) do
    symptom_data
      |> format_scale_list([], 1)
      |> Enum.map(fn score ->
        case score do
          "10 - Major effect " ->
            10
          "0 -  Very little effect" ->
            0
          _ ->
            score
        end
      end)
      |> Enum.join(",")
  end

  defp format_dates_list(date, list, 7) do
   day_of_week = if Date.day_of_week(date) == 7 do
     0
   else
     Date.day_of_week(date)
   end
   day_month = day_month(date)
   List.insert_at(list, day_of_week, day_month)
  end

  defp format_dates_list(date, list, n) do
   # add start date to list at index == day of week_data
   day_of_week = if Date.day_of_week(date) == 7 do
     0
   else
     Date.day_of_week(date)
   end
   day_month = day_month(date)
   new_list = List.insert_at(list, day_of_week, day_month)
   new_date = Timex.shift(date, days: 1)
   format_dates_list(new_date, new_list, n + 1)
  end

  defp format_hours_list(data, list, 7) do
    # add hours to front of list
    if Enum.any?(data, fn(struct) ->
      Date.day_of_week(struct.for_date) == 7
    end) do
      hours_slept = Enum.filter(data, fn struct ->
                  Date.day_of_week(struct.for_date) == 7 end)
                  |> Enum.at(0)
                  |> Map.get(:hours_slept)
      List.insert_at(list, 0, hours_slept)
    else
      List.insert_at(list, 0, "null")
    end
  end

  defp format_hours_list(data, list, n) do
    # add hours_slept to list if day == n, else add 0.
    new_list = if Enum.any?(data, fn(struct) ->
                  Date.day_of_week(struct.for_date) == n
                end) do
                  insert_hours_slept(data, list, n)
                else
                  List.insert_at(list, n - 1, "null")
                end
    format_hours_list(data, new_list, n + 1)
  end

  defp format_scale_list(data, list, 7) do
    if Enum.any?(data, fn(struct) ->
      Date.day_of_week(struct.inserted_at) == 7
    end) do
      scale = Enum.filter(data, fn struct ->
                  Date.day_of_week(struct.inserted_at) == 7 end)
                  |> Enum.at(0)
                  |> Map.get(:affected_scale)
      List.insert_at(list, 0, scale)
    else
      List.insert_at(list, 0, "null")
    end
  end

  defp format_scale_list(data, list, n) do
    new_list = if Enum.any?(data, fn(struct) ->
                  Date.day_of_week(struct.inserted_at) == n
                end) do
                  insert_scale(data, list, n)
                else
                  List.insert_at(list, n - 1, "null")
                end
    format_scale_list(data, new_list, n + 1)
  end

  defp insert_hours_slept(data, list, n) do
    hours_slept = Enum.filter(data, fn struct ->
                Date.day_of_week(struct.for_date) == n end)
                |> Enum.at(0)
                |> Map.get(:hours_slept)

    List.insert_at(list, n - 1, hours_slept)
  end

  defp insert_scale(data, list, n) do
    scale = Enum.filter(data, fn struct ->
      Date.day_of_week(struct.inserted_at) == n end)
      |> Enum.at(0)
      |> Map.get(:affected_scale)

    List.insert_at(list, n - 1, scale)
  end

  defp day_month(date) do
    day = if date.day < 10 do
      "0" <> Integer.to_string(date.day)
    else
      Integer.to_string(date.day)
    end

    month = if date.month < 10 do
      "0" <> Integer.to_string(date.month)
    else
      Integer.to_string(date.month)
    end
    day <> "/" <> month
  end

  @days_of_week ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
  defp day_of_week(_date, 6) do
    @days_of_week |> Enum.at(6)
  end

  defp day_of_week(date, n) do
    if Date.day_of_week(date) == n do
      @days_of_week |> Enum.at(n - 1)
    else
      day_of_week(date, n + 1)
    end
  end

  def date_with_day_and_month(date) do
    day_of_week(date, 0) <> " " <> Integer.to_string(date.day) <> " " <> Timex.month_name(date.month)
  end

  def printed_time(naive_date_time) do
    [hours, minutes | _] = naive_date_time
    |> NaiveDateTime.to_time()
    |> Time.to_string
    |> String.split(":")

    Enum.join([hours, ":" , minutes])
  end
end
