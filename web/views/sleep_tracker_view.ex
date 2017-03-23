defmodule Healthlocker.SleepTrackerView do
  use Healthlocker.Web, :view

  @root_dir File.cwd!
  @hours_slept_raw Path.join(~w(#{@root_dir} web/templates hours_slept.txt))

  @wake_count_raw Path.join(~w(#{@root_dir} web/templates wake_count.txt))

  def hours_slept do
    # load hours_slept from file
    hours_slept = @hours_slept_raw |> File.read!

    # split on line breaks to separate the hours_slept:
    hours_slept_list = String.split(hours_slept, "\n")
                    |> List.delete("")

    # return the hours_slept list
    hours_slept_list
  end

  def wake_count do
    # load wake_count from file
    wake_count = @wake_count_raw |> File.read!

    # split on line breaks to separate the wake_count:
    wake_count_list = String.split(wake_count, "\n")
                    |> List.delete("")

    # return the wake_count list
    wake_count_list
  end
end
