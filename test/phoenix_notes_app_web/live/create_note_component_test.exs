defmodule PhoenixNotesAppWeb.CreateNoteComponentTest do
  use PhoenixNotesAppWeb.ConnCase, async: true
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest

  alias PhoenixNotesApp.Users

  defp create_user do
    attrs = %{
      "username" => "alice",
      "email" => "alice@example.com",
      "hashed_password" => "secret123"
    }

    {:ok, user} = Users.create_user(attrs)
    user
  end

  defp log_in(conn, user) do
    init_test_session(conn, %{"user_id" => user.id})
  end

  test "close create note modal", %{conn: conn} do
    user = create_user()

    {:ok, view, _html} =
      conn
      |> log_in(user)
      |> live(~p"/notes")

    view
    |> element("#open-create-note-modal")
    |> render_click()

    assert has_element?(view, "#show-create-note-modal")

    view
    |> element("#close-create-note-modal")
    |> render_click()

    refute has_element?(view, "#show-create-note-modal")
  end

end
