defmodule Healthlocker.ComponentView do
  use Healthlocker.Web, :view

  def get_options(option_type) do
    # load security questions from file
    questions = "web/static/assets/#{option_type}.txt" |> File.read!

    # split on line breaks to separate the questions:
    questions_list = String.split(questions, "\n")
                    |> List.delete("")

    # return the questions list
    questions_list
  end

  # gives the date in the format DD-MM-YYYY
  def pretty_date(date) do
    day = if date.day < 10 do
      "0" <> Integer.to_string(date.day)
    else
      Integer.to_string(date.day)
    end

    month = if date.month < 10 do
      "0" <> Integer.to_string(date.month)
    else
      Integer.to_string(date.month)
    end

    year = Integer.to_string(date.year)
    day <> "-" <> month <> "-" <> year
  end
end
