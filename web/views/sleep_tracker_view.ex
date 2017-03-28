defmodule Healthlocker.SleepTrackerView do
  use Healthlocker.Web, :view

  @root_dir File.cwd!

  @wake_count_raw Path.join(~w(#{@root_dir} web/templates wake_count.txt))

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
