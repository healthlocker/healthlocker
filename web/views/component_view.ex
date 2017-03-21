defmodule Healthlocker.ComponentView do
  use Healthlocker.Web, :view
  @root_dir File.cwd!
  @questions_raw Path.join(~w(#{@root_dir} web/templates security_questions.txt))

  def security_questions do
    # load security questions from file
    questions = @questions_raw |> File.read!

    # split on line breaks to separate the questions:
    questions_array = String.split(questions, "\n")

    # create a map from the questions array
    questions_map = %{}
    # create an array where "question: question"

    # gets a map which displays in template, except there is an
    # empty string at the beginning
    map = Enum.reduce questions_array, %{}, fn x, acc ->
      Map.put(acc, x, x)
    end

    # return the questions map
    map
  end

end
