defmodule Healthlocker.ComponentViewTest do
  use Healthlocker.ConnCase, async: true
  alias Healthlocker.{ComponentView,User}

  # @valid_changeset <action: nil, changes: %{}, errors: [], valid?: false>
  describe "changeset with and without errors" do
    setup do
      start_changeset = User.password_changeset(%User{})
      error_changeset = start_changeset
                      |> Ecto.Changeset.add_error(:password_check, "Does not match")

      {:ok, start_changeset: start_changeset, error_changeset: error_changeset,
    full_changeset: %{error_changeset | action: :update}}
    end

    test "highlight_errors gives new class when there are errors & action", %{full_changeset: full_changeset} do
      actual = ComponentView.highlight_errors(full_changeset, :password_check)
      expected = "hl-input-error hl-bg-error"
      assert actual == expected
    end

    test "highlight_errors gives empty string when no errors or action", %{start_changeset: start_changeset} do
      actual = ComponentView.highlight_errors(start_changeset, :password)
      expected = ""
      assert actual == expected
    end

    test "highlight_errors gives empty string when errors but no action", %{error_changeset: error_changeset} do
      actual = ComponentView.highlight_errors(error_changeset, :password)
      expected = ""
      assert actual == expected
    end
  end

  test "get_options returns a list of strings for security_questions" do
    actual = ComponentView.get_options("security_questions")
    expected_list = is_list(actual)
    expect_strings_in_list = Enum.all?(actual, fn x -> is_bitstring(x) end)
    assert expected_list
    assert expect_strings_in_list
  end

  test "get_options returns a list of strings for hours_slept" do
    actual = ComponentView.get_options("hours_slept")
    expected_list = is_list(actual)
    expect_strings_in_list = Enum.all?(actual, fn x -> is_bitstring(x) end)
    assert expected_list
    assert expect_strings_in_list
  end

  test "get_options returns a list of strings for wake_count" do
    actual = ComponentView.get_options("wake_count")
    expected_list = is_list(actual)
    expect_strings_in_list = Enum.all?(actual, fn x -> is_bitstring(x) end)
    assert expected_list
    assert expect_strings_in_list
  end

  test "pretty_date returns date in the format DD/MM/YYYY" do
    {:ok, date} = Date.new(2017, 4, 10)
    actual =  ComponentView.pretty_date(date)
    expected = "10/04/2017"
    assert actual == expected
  end

  test "markdown converts markdown to html" do
    {:safe, actual} = ComponentView.markdown("**tip title**\n\ntip body\n\n#Tip #Connect")
    bold_title = "<p><strong>tip title</strong></p>"
    tip_link = "<a href=\"/tips\""
    category_link = "<a href=\"/tips?tag=Connect\""
    assert String.contains?(actual, bold_title)
    assert String.contains?(actual, tip_link)
    assert String.contains?(actual, category_link)
  end

  test "full_name gives the full name of the user for maps with atoms" do
    actual = ComponentView.full_name(%{first_name: "First", last_name: "Last"})
    expected = "First Last"
    assert actual == expected
  end

  test "full_name gives the full name of the user" do
    actual = ComponentView.full_name(%{"first_name" => "First", "last_name" => "Last"})
    expected = "First Last"
    assert actual == expected
  end

  test "full_name gives empty string with first & last name are nil" do
    actual = ComponentView.full_name(%{first_name: nil, last_name: nil})
    expected = " "
    assert actual == expected
  end

  test "epjs_full_name gives the full name of clinician for maps with atoms" do
    actual = ComponentView.epjs_full_name(%{Staff_Name: "First Last"})
    expected = "First Last"
    assert actual == expected
  end

  test "epjs_full_name gives empty string with first & last name are nil" do
    actual = ComponentView.epjs_full_name(%{Staff_Name: nil})
    expected = nil
    assert actual == expected
  end

  test "epjs_job_title gives the full name of clinician" do
    actual = ComponentView.epjs_job_title(%{Job_Title: "Manager"})
    expected = "Manager"
    assert actual == expected
  end

  test "epjs_job_title gives empty string with first & last name are nil" do
    actual = ComponentView.epjs_job_title(%{Job_Title: nil})
    expected = nil
    assert actual == expected
  end

end
