defmodule Healthlocker.SlamControllerTest do
  use Healthlocker.ConnCase
  alias Healthlocker.User

  setup do
    %User{
      id: 123456,
      name: "MyName",
      email: "abc@gmail.com",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      security_question: "Question?",
      security_answer: "Answer"
    } |> Repo.insert

    {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123456)) }
  end

  test "renders form to connect with slam", %{conn: conn} do
    conn = get(conn, slam_path(conn, :new))
    assert html_response(conn, 200) =~ ~r/Connect/
  end
end
