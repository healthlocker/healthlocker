defmodule Healthlocker.TrackerController do
  use Healthlocker.Web, :controller
  use Timex
  alias Healthlocker.{Symptom, SymptomTracker, SleepTracker}

  def create_date_list(list, date, 6) do
    list
    |> List.insert_at(7, %{inserted_at: date, sleep_data: %{}, symptom_data: %{}})
  end

  def create_date_list(list, date, n) do
    list
    |> List.insert_at(n, %{inserted_at: date, sleep_data: %{}, symptom_data: %{}})
    |> create_date_list(Timex.shift(date, days: -1), n + 1)
  end

  def merge_map_data(list, data_list, atom, 6) do
    list
    |> List.update_at(6, fn map ->
      case Enum.filter(data_list, fn data_map ->
        Date.compare(NaiveDateTime.to_date(map.inserted_at), NaiveDateTime.to_date(data_map.inserted_at)) == :eq
      end) do
        [head | _] ->
          head
          |> Map.from_struct
          |> Map.merge(map[atom])
        [] ->
          map
      end
    end)
  end

  def merge_map_data(list, data_list, atom, n) do
    list
    |> List.update_at(n, fn map ->
      case Enum.filter(data_list, fn data_map ->
        Date.compare(NaiveDateTime.to_date(map.inserted_at), NaiveDateTime.to_date(data_map.inserted_at)) == :eq
      end) do
        [head | _] ->
          map
          |> Map.put(atom, head)
        [] ->
          map
      end
    end)
    |> merge_map_data(data_list, atom, n + 1)
  end

  def merge_tracking_data(list, sleep_data, symptom_data, date_time) do
    list
    |> create_date_list(date_time, 0)
    |> merge_map_data(sleep_data, :sleep_data, 0)
    |> merge_map_data(symptom_data, :symptom_data, 0)
  end


  def get_symptom_tracking_data(date, user_id) do
    case Repo.get_by(Symptom, user_id: user_id) do
      nil ->
        []
      symptom ->
        SymptomTracker
        |> SymptomTracker.symptom_tracking_data_query(symptom, date)
        |> Repo.all
    end
  end

  def get_sleep(conn, date) do
    user_id = conn.assigns.current_user.id
    SleepTracker
      |> SleepTracker.get_sleep_data(user_id, date)
      |> Repo.all
  end

  def index(conn, _params) do
    sleep_data = get_sleep(conn, Date.utc_today())
    symptom_data = get_symptom_tracking_data(DateTime.utc_now(), conn.assigns.current_user.id)
    merged_data = merge_tracking_data([], sleep_data, symptom_data, NaiveDateTime.utc_now())
    date = Date.to_iso8601(Date.utc_today())

    render(conn, "index.html", sleep_data: sleep_data, date: date, symptom_data: symptom_data,
          merged_data: merged_data)
  end

  def prev_date(conn, %{"sleep_tracker_id" => end_date}) do
    # need to go back & forth with iso dates for display purposes. An elixir
    # date won't render on the page, and iso dates can't be used with timex for
    # shifting back 7 days

    {:ok, iex_date} = Date.from_iso8601(end_date)
    shifted_date = Timex.shift(iex_date, days: -7)
    date = Date.to_iso8601(shifted_date)

    {:ok, date_time, _} = DateTime.from_iso8601(end_date <> "T23:59:59Z")
    shifted_date_time = Timex.shift(date_time, days: -7)

    sleep_data = get_sleep(conn, shifted_date)
    symptom_data = get_symptom_tracking_data(shifted_date_time, conn.assigns.current_user.id)

    render(conn, "index.html", sleep_data: sleep_data, date: date, symptom_data: symptom_data)
  end

  def next_date(conn, %{"sleep_tracker_id" => end_date}) do
    # need to go back & forth with iso dates for display purposes. An elixir
    # date won't render on the page, and iso dates can't be used with timex for
    # shifting back 7 days

    {:ok, iex_date} = Date.from_iso8601(end_date)
    shifted_date = Timex.shift(iex_date, days: 7)
    date = Date.to_iso8601(shifted_date)

    {:ok, date_time, _} = DateTime.from_iso8601(end_date <> "T23:59:59Z")
    shifted_date_time = Timex.shift(date_time, days: 7)

    sleep_data = get_sleep(conn, shifted_date)
    symptom_data = get_symptom_tracking_data(shifted_date_time, conn.assigns.current_user.id)

    render(conn, "index.html", sleep_data: sleep_data, date: date, symptom_data: symptom_data)
  end
end
