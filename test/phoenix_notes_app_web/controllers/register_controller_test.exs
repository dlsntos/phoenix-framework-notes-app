defmodule PhoenixNotesAppWeb.RegisterControllerTest do
  use PhoenixNotesAppWeb.ConnCase, async: true

  test "GET /register render register page", %{conn: conn} do
    conn = get(conn, ~p"/register")
    assert html_response(conn, 200)
  end

  test "POST /register, register with complete credentials", %{conn: conn} do
    conn = post(conn, ~p"/register", %{
      "user" => %{"username" => "test user", "email" => "iex@example.com", "hashed_password" => "secret"}
    })

    assert redirected_to(conn) == ~p"/login"
  end
end
