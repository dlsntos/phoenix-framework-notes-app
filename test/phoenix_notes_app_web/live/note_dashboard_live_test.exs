defmodule PhoenixNotesAppWeb.NoteDashboardLiveTest do
  use PhoenixNotesAppWeb.ConnCase
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

  test "renders notes list", %{conn: conn} do
    user = create_user()
    note = create_note(user)

    {:ok, view, _html} =
      conn
      |> log_in(user)
      |> live(~p"/notes")

    assert has_element?(view, "#note-item-#{note.id}")
  end

  test "search filters notes", %{conn: conn} do
    user = create_user()
    match = create_note(user, %{"title" => "Alpha"})
    other = create_note(user, %{"title" => "Beta"})

    {:ok, view, _html} =
      conn
      |> log_in(user)
      |> live(~p"/notes")

    render_change(view, "search", %{"search" => %{"query" => "Alp"}})

    assert has_element?(view, "#note-item-#{match.id}")
    refute has_element?(view, "#note-item-#{other.id}")
  end

  test "open view modal and enable edit", %{conn: conn} do
    user = create_user()
    note = create_note(user)

    {:ok, view, _html} =
      conn
      |> log_in(user)
      |> live(~p"/notes")

    view
    |> element("button[phx-click='open-view_note_modal'][phx-value-id='#{note.id}']")
    |> render_click()

    assert has_element?(view, "#view-note-modal")

    view
    |> element("#view-note-modal button[phx-click='enable-edit']")
    |> render_click()

    assert has_element?(view, "#edit-note-form-#{note.id}")
  end

  test "open create note modal", %{conn: conn} do
    user = create_user()

    {:ok, view, _html} =
      conn
      |> log_in(user)
      |> live(~p"/notes")

    view
    |> element("button[phx-click='open-create-note-modal']")
    |> render_click()

    assert has_element?(view, "#show-create-note-modal")
  end
end
