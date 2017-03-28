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
end
