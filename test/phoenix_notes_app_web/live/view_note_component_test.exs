defmodule PhoenixNotesAppWeb.ViewNoteComponentTest do
  use PhoenixNotesAppWeb.ConnCase, async: true
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest

  alias PhoenixNotesApp.Users
  alias PhoenixNotesApp.Notes

  defp create_user do
    attrs = %{
      "username" => "alice",
      "email" => "alice@example.com",
      "hashed_password" => "secret123"
    }

    {:ok, user} = Users.create_user(attrs)
    user
  end

  defp create_note(user, attrs \\ %{}) do
    attrs =
      Map.merge(
        %{"title" => "First note", "content" => "hello", "user_id" => user.id},
        attrs
      )

    {:ok, note} = Notes.create_note(attrs)
    note
  end

  defp log_in(conn, user) do
    init_test_session(conn, %{"user_id" => user.id})
  end


  test "close view note modal", %{conn: conn} do
    user = create_user()
    note = create_note(user)

    {:ok, view, _html} =
      conn
      |> log_in(user)
      |> live(~p"/notes")

    view
    |> element("#note-item-#{note.id} button[phx-click='open-view_note_modal']")
    |> render_click()

    assert has_element?(view, "#view-note-modal")

    view
    |> element("#close-view-note-modal")
    |> render_click()

    refute has_element?(view, "#view-note-modal")
  end
end
