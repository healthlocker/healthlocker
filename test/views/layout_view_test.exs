defmodule Healthlocker.LayoutViewTest do
  use Healthlocker.ConnCase, async: true
  alias Healthlocker.{LayoutView, User}

  test "care_team? with caring for" do
    assert LayoutView.care_team?(struct(User, %{caring: [1]}))
  end

  test "care_team? with no caring for and role is carer" do
    assert LayoutView.care_team?(struct(User, %{caring: [], role: "carer"}))
  end

  test "care_team? with no caring for and role is not carer" do
    refute LayoutView.care_team?(struct(User, %{caring: [], role: "something_else"}))
  end
end
