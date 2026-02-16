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

  test "GET /login render login page", %{conn: conn} do
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

  test "POST /login with invalid credentials", %{conn: conn} do
    user = reg_user()

    conn =
      post(conn, ~p"/login", %{
        "user" => %{"email" => user.email, "password" => "wrongpassword123"}
      })

    assert html_response(conn, 200)
    assert Phoenix.Flash.get(conn.assigns.flash, :error) == "Invalid email or password"
  end

  test "DELETE /logout clears session", %{conn: conn} do
    user = reg_user()
    conn =
      conn
      |> init_test_session(%{user_id: user.id})
      |> delete(~p"/logout")

    assert redirected_to(conn) == ~p"/login"
  end
end
