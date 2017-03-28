defmodule Healthlocker.ComponentView do
  use Healthlocker.Web, :view

  def security_questions do
    # load security questions from file
    questions = "web/static/assets/security_questions.txt" |> File.read!

    # split on line breaks to separate the questions:
    questions_list = String.split(questions, "\n")
                    |> List.delete("")

    # return the questions list
    questions_list
  end
end
