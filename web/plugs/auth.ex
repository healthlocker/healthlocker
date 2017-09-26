defmodule Healthlocker.Plugs.Auth do
  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  use Timex

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    cond do
      session_expired?(conn) ->
        logout(conn)
      user = conn.assigns[:current_user] ->
        conn
        |> put_session(:expiry_time, gen_expiration_datetime_string())
        |> put_current_user(user)
      user = user_id && repo.get(Healthlocker.User, user_id) |> repo.preload(:likes) ->
        conn
        |> put_session(:expiry_time, gen_expiration_datetime_string())
        |> put_current_user(user)
      true ->
        conn
        |> assign(:current_user, nil)
        |> put_session(:expiry_time, false)
    end
  end

  def login(conn, user) do
    conn
    |> put_current_user(user)
    |> put_session(:user_id, user.id)
    |> put_session(:expiry_time, gen_expiration_datetime_string())
    |> configure_session(renew: true)
  end

  defp put_current_user(conn, user) do
    token = Phoenix.Token.sign(conn, "user socket", user.id)

    conn
    |> assign(:current_user, user)
    |> assign(:user_token, token)
  end

  def check_password(conn, id, given_pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get(Healthlocker.User, id) |> repo.preload(:likes)

    cond do
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, conn}
      user ->
        {:error, :wrong_password, conn}
    end
  end

  def email_and_pass_login(conn, email, given_pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(Healthlocker.User, email: email) |> repo.preload(:likes)

    cond do
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  defp gen_expiration_datetime_string do
    Timex.now |> Timex.shift(minutes: +String.to_integer(System.get_env("SESSION_TIMEOUT"))) |> Timex.format!("{ISO:Extended}")
  end

  defp session_expired?(conn) do
    if get_session(conn, :expiry_time) do
      expiry_time = get_session(conn, :expiry_time) |> Timex.parse!("{ISO:Extended}")
      Timex.after?(Timex.now, expiry_time)
    else
      get_session(conn, :expiry_time)
    end
  end

  def logout(conn) do
    conn
    |> configure_session(drop: true)
    |> put_session(:expiry_time, false)
  end
end
