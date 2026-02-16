defmodule PhoenixNotesAppWeb.LoginControllerTest do
  use PhoenixNotesAppWeb.ConnCase, async: true

  alias PhoenixNotesApp.Users

  defp reg_user(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{username: "Test user", email: "iex@example.com", password: "secret123"})
      |> Users.create_user()

    user
  end

  test "GET /login", %{conn: conn} do
    conn = get(conn, ~p"/login")
    assert html_response(conn, 200)
  end

end
