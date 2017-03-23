defmodule Healthlocker.SleepTrackerControllerTest do
  use Healthlocker.ConnCase, async: false

  test "/sleep-tracker :: index", %{conn: conn} do
    conn = get conn, sleep_tracker_path(conn, :index)
    assert html_response(conn, 200) =~ "Sleep Tracker"
  end
end
