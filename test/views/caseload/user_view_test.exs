defmodule Healthlocker.Caseload.UserViewTest do
  use Healthlocker.ConnCase, async: true
  alias Healthlocker.Caseload.UserView

  test "format_nhs_number returns correct nhs number format" do
    actual = UserView.format_nhs_number("1234567890")
    expected = "123 456 7890"
    assert actual == expected
  end
end
