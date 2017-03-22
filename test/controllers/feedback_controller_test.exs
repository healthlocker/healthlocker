defmodule Healthlocker.FeedbackControllerTest do
  use Healthlocker.ConnCase, async: false

  import Mock

  test "/feedback :: index", %{conn: conn} do
    conn = get conn, feedback_path(conn, :index)
    assert html_response(conn, 200) =~ "Tell us about your experience with Healthlocker"
  end

  test "/feedback :: create", %{conn: conn} do
    with_mock Healthlocker.Mailer, [deliver_now: fn(_) -> nil end] do
      conn = post conn, feedback_path(conn, :create,
      %{"feedback" => %{"subject" => "Here's a subject", "content" => "With some content"}})
      assert redirected_to(conn, 302) =~ "/feedback"
    end
  end
end
