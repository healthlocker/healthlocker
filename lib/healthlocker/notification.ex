defmodule Healthlocker.Notication do
  alias Healthlocker.{Message, User}
  use Healthlocker.Web, :controller

  def send() do
    date = NaiveDateTime.utc_now()
    users = get_slam_users()
    messages = get_new_messages(date)
  end

  def get_new_messages(date) do
    query =
      from m in Message,
      where: m.inserted_at > ^Timex.shift(date, hours: -5) #change to days: -1
    Repo.all(query)
  end

  def get_slam_users() do
    query = from u in User, where: u.role == "slam_user"
    Repo.all(query)
  end

  def messages_send_by_slam_user(messages, users) do
    user_ids = Enum.map(users, &(&1.id))
    messages
    |> Enum.filter(&(Enum.member?(user_ids, &1.user_id)))
  end
end
