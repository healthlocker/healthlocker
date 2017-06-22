defmodule Healthlocker.ButtonController do
  use Healthlocker.Web, :controller

  def index(conn, _params) do
    dog =
      case File.read("doggy.jpg") do # won't be a dog
        {:ok, binary} -> Base.encode64(binary)
        {:error, _} -> IO.puts("ohhh nooooooo") # will be a base encode of deault button
      end

    render(conn, "index.html", dog: dog)
  end
end
