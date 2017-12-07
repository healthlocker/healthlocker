defmodule Healthlocker.CopingStrategyViewTest do
  use Healthlocker.ConnCase, async: true
  alias Healthlocker.CopingStrategyView

  test "checks format_output handles a case where no string is given" do
    assert CopingStrategyView.format_output(nil, " ") == nil
  end

  test "checks format_output handles strings as expected" do
    {:safe, result1} = CopingStrategyView.format_output("hey  ", " ")
    {:safe, result2} = CopingStrategyView.format_output("hey you", " ")
    assert result1 == "<p>hey</p>"
    assert result2 == "<p>hey you</p>"
  end
end
