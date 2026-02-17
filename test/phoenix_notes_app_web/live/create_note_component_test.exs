defmodule PhoenixNotesAppWeb.CreateNoteComponentTest do
  use PhoenixNotesAppWeb.ConnCase, async: true
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

  test "create a new note", %{conn: conn} do
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
    |> element("#create-note-form")
    |> render_submit(%{"note" => %{
      "title" => "Grocery List",
      "content" => "1. eggs\n2. flour\n3. coffee"
    }})

    notes = PhoenixNotesApp.Notes.get_all_notes_by_userid(user.id)
    assert Enum.any?(notes, fn n -> n.title == "Grocery List" end)
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
