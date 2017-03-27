defmodule Healthlocker.ComponentView do
  use Healthlocker.Web, :view

  def security_questions do
    # load security questions from file
    questions = "web/static/assets/security_questions.txt" |> File.read!

    # split on line breaks to separate the questions:
    questions_array = String.split(questions, "\n")

    # gets a map which displays in template, except there is an
    # empty string at the beginning
    map = Enum.reduce questions_array, %{}, fn x, acc ->
      Map.put(acc, x, x)
    end

    # delete any empty string "" keys
    questions_map = Map.delete(map, map[""])
    # return the questions map
    questions_map
  end
end
