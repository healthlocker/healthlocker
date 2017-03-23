defmodule Healthlocker.ComponentView do
  use Healthlocker.Web, :view

  @root_dir File.cwd!
  @questions_raw Path.join(~w(#{@root_dir} web/templates security_questions.txt))

  def security_questions do
    # load security questions from file
    questions = @questions_raw |> File.read!

    # split on line breaks to separate the questions:
    questions_list = String.split(questions, "\n")
                    |> List.delete("")

    # return the questions list
    questions_list
  end
end
