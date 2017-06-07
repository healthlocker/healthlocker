defmodule Healthlocker.TipViewTest do
  use Healthlocker.ConnCase, async: true

  alias Healthlocker.TipView

  test "get_category finds the correct category" do
    actual = TipView.get_category("tag=Connect")
    expected = "Connect"
    assert actual == expected
  end

  test "category_description returns the correct description" do
    actual = TipView.category_description("tag=Connect")
    expected = " with the people around us. Building stronger, wider social
      connections can help us feel happier and more secure, and give us a
      greater sense of purpose."
    assert actual == expected
  end

  test "category_question finds the correct question" do
    actual = TipView.category_question("tag=Connect")
    expected = "Who might you want to connect more with?"
    assert actual == expected
  end

  test "get_category finds the correct category if lowercase" do
    actual = TipView.get_category("tag=connect")
    expected = "Connect"
    assert actual == expected
  end
end
