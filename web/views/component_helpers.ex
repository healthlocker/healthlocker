defmodule Healthlocker.ComponentHelpers do
  @moduledoc """
  Convience methods for rendering our components.
  """

  @doc false
  defmacro __using__(_) do
    quote do
      import Healthlocker.ComponentHelpers.Button
      import Healthlocker.ComponentHelpers.Link
    end
  end
end
