defmodule Healthlocker.CareTeamChannel do
  use Healthlocker.Web, :channel

  def join("care-team:" <> user_id, _params, socket) do
    {:ok, assign(socket, :user_id, String.to_integer(user_id)) }
  end
end
