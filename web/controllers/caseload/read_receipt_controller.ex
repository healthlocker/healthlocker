defmodule Healthlocker.Caseload.ReadReceiptController do
  use Healthlocker.Web, :controller
  alias Healthlocker.{Message, ReadReceipt}

  def create(conn, %{"message_id" => message_id, "read_receipt" => _read_receipt_params}) do
    message = find_message(message_id)

    changeset = ReadReceipt.changeset(%ReadReceipt{}, %{
      message_id: message.id,
      user_id: conn.assigns.current_user.id,
      read: true
    })

    case Repo.insert(changeset) do
      {:ok, _read_receipt} ->
        conn
        |> put_flash(:info, "Read successful")
        |> redirect(to: caseload_user_room_path(conn, :show, 5, 1))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: caseload_user_room_path(conn, :show, 5, 1))
    end
  end

  defp find_message(message_id) do
    # user.rooms.message.find(message_id)
    Repo.get(Message, message_id)
  end
end
