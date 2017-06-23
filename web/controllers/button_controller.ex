defmodule Healthlocker.ButtonController do
  use Healthlocker.Web, :controller

  def index(conn, _params) do
    # for now this only uses one button, so the same image is loaded on error
    # in the future, the case would try read a file that's put in as a param,
    # and if it didn't exist it would load the default.
    button =
      case File.read("web/static/assets/images/epjs_button.png") do # won't be a dog
        {:ok, binary} ->
          Base.encode64(binary)
        {:error, _} ->
          binary = File.read!("web/static/assets/images/epjs_button.png")
          Base.encode64(binary)
      end

    render(conn, "index.html", button: button)
  end
end
