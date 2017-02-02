defmodule Healthlocker.PostViewTest do
  use Healthlocker.ConnCase, async: true

  test "converts markdown to html" do
    {:safe, result} = Healthlocker.PostView.markdown("**Hello, world!**")
    assert String.contains? result, "<strong>Hello, world!</strong>"
  end
end
