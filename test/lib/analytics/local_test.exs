defmodule Healthlocker.Analytics.LocalTest do
  use ExUnit.Case, async: true

  test "identify/2" do
    assert Healthlocker.Analytics.Local.identify("12345", {}) == :ok
  end

  test "track/3" do
    status = Healthlocker.Analytics.Local.track("12345", "signed_up", {})
    assert status == :ok
  end
end
