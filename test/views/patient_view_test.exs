defmodule Healthlocker.PatientViewTest do
  use Healthlocker.ConnCase, async: true
  alias Healthlocker.PatientView

  test "format_nhs_number returns correct nhs number format" do
    actual = PatientView.format_nhs_number("1234567890")
    expected = "123 456 7890"
    assert actual == expected
  end
end
