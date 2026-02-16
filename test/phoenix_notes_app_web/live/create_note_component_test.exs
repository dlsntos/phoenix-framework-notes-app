defmodule PhoenixNotesAppWeb.CreateNoteComponentTest do
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


end
