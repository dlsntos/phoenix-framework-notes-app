defmodule PhoenixNotesAppWeb.RegisterControllerTest do
  use PhoenixNotesAppWeb.ConnCase, async: true

  test "GET /register render register page", %{conn: conn} do
    conn = get(conn, ~p"/register")
    assert html_response(conn, 200)
  end
end
