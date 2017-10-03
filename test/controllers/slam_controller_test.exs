defmodule Healthlocker.SlamControllerTest do
  use Healthlocker.ConnCase
  alias Healthlocker.{User, EPJSUser, ReadOnlyRepo}

  @valid_attrs %{
    first_name: "Kat",
    last_name: "Bow",
    forename: "Lisa",
    surname: "Sandoval",
    date_of_birth: "01/07/1997",
    nhs_number: "2848783643"
  }
  @invalid_carer %{
    forename: "Lisa",
    surname: "Sandoval",
    date_of_birth: "01/07/1997",
    nhs_number: "2848783643"
  }
  @invalid_slam %{
    first_name: "Kat",
    last_name: "Bow",
    forename: "Lisa",
    surname: "Sandoval",
    date_of_birth: "01/07/1997",
    nhs_number: "regyfuihweufgiui2"
  }
  @invalid_attrs %{}

  setup do
    %User{
      id: 123456,
      first_name: "My",
      last_name: "Name",
      email: "abc@gmail.com",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      security_question: "Question?",
      security_answer: "Answer",
      slam_id: 203
    } |> Repo.insert

    birthday = DateTime.from_naive!(~N[1997-07-01 00:00:00.00], "Etc/UTC")

    %EPJSUser{
      Patient_ID: 203,
      Surname: "Sandoval",
      Forename: "Lisa",
      NHS_Number: "2848783643",
      DOB: birthday,
    } |> ReadOnlyRepo.insert

    Mix.Tasks.Healthlocker.Room.Create.run("run")

    {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123456)) }
  end

  test "renders form to connect with slam", %{conn: conn} do
    conn = get(conn, slam_path(conn, :new))
    assert html_response(conn, 200) =~ ~r/Connect/
  end

  # can only test with mssql database set up
  # test "POST /slam with valid attrs", %{conn: conn} do
  #   conn = post(conn, slam_path(conn, :create), carer_connection: @valid_attrs)
  #   assert redirected_to(conn) == account_path(conn, :index)
  # end

  # can only test with mssql database set up
  # test "POST /slam without carer details", %{conn: conn} do
  #   conn = post conn, slam_path(conn, :create), carer_connection: @invalid_carer
  #   assert html_response(conn, 200) =~ ~r/Connect/
  # end

  # can only test with mssql database set up
  # test "POST /slam with incorrect slam details", %{conn: conn} do
  #   conn = post conn, slam_path(conn, :create), carer_connection: @invalid_slam
  #   assert html_response(conn, 200) =~ ~r/Connect/
  # end

  test "POST /slam with blank form", %{conn: conn} do
    conn = post conn, slam_path(conn, :create), carer_connection: @invalid_attrs
    assert html_response(conn, 200) =~ ~r/Connect/
  end
end
