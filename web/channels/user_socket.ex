defmodule Healthlocker.UserSocket do
  use Phoenix.Socket

  channel "room:*", Healthlocker.RoomChannel

  transport :websocket, Phoenix.Transports.WebSocket, timeout: 45_000

  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
      {:ok, user_id} ->
        {:ok, assign(socket, :user_id, user_id)}
      {:error, _message} ->
        :error
    end
  end

  def connect(_params, _socket), do: :error

  def id(socket), do: "users_socket:#{socket.assigns.user_id}"
end
