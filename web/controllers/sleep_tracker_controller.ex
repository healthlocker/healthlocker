defmodule Healthlocker.SleepTrackerController do
  use Healthlocker.Web, :controller

  alias Healthlocker.SleepTracker

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, %{"user_params" => user_params}) do
    changeset = SleepTracker.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end
end
