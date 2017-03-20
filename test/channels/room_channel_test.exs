defmodule Healthlocker.RoomChannelTest do
  use Healthlocker.ChannelCase

  alias Healthlocker.RoomChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{user_id: 123456})
      |> subscribe_and_join(RoomChannel, "room:general")

    %Healthlocker.User{
      id: 123456,
      name: "MyName",
      email: "abc@gmail.com",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password")
    } |> Repo.insert

    {:ok, socket: socket}
  end

  test "new:msg replies with status ok", %{socket: socket} do
    ref = push socket, "new:msg", %{"name" => "Me", "body" => "hello there"}
    assert_reply ref, :ok, %{msg: "hello there"}
  end

  test "new:msg replies with status error", %{socket: socket} do
    ref = push socket, "new:msg", %{}
    assert_reply ref, :error
  end

  test "new:msg broadcasts to room:general", %{socket: socket} do
    push socket, "new:msg", %{"name" => "Me", "body" => "hello there"}
    assert_broadcast "new:msg", %{name: "Me", body: "hello there"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "new:msg", %{"name" => "Me", "body" => "hello there"}
    assert_push "new:msg", %{"name" => "Me", "body" => "hello there"}
  end
end
