defmodule PhoenixNotesAppWeb.LoginControllerTest do
  use PhoenixNotesAppWeb.ConnCase, async: true

  alias PhoenixNotesApp.Users

  defp reg_user(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        "username" => "Test user",
        "email" => "iex@example.com",
        "hashed_password" => "secret123"})
      |> Users.create_user()

    user
  end

  test "GET /login", %{conn: conn} do
    conn = get(conn, ~p"/login")
    assert html_response(conn, 200)
  end

  test "POST /login with valid credentials", %{conn: conn} do
    user = reg_user()

    conn =
      post(conn, ~p"/login", %{
        "user" => %{"email" => user.email, "password" => "secret123"}
      })

    assert redirected_to(conn) == ~p"/notes"
    assert get_session(conn, :user_id) == user.id
  end
end
