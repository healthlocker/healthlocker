defmodule Healthlocker.CopingStrategyViewTest do
  use Healthlocker.ConnCase, async: true
  alias Healthlocker.CopingStrategyView

  test "checks format_output will handle empty strings as expected" do
    assert CopingStrategyView.format_output(nil, " ") == nil
    {:safe, result} = CopingStrategyView.format_output("   ", " ")
    assert result == ""
  end

  test "checks format_output handles strings as expected" do
    {:safe, result1} = CopingStrategyView.format_output("hey  ", " ")
    {:safe, result2} = CopingStrategyView.format_output("hey you", " ")
    assert result1 == "<p>hey</p>"
    assert result2 == "<p>hey you</p>"
  end
end
