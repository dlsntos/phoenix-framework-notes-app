defmodule PhoenixNotesAppWeb.NotesTest do
use PhoenixNotesApp.DataCase, async: true
use ExUnit.Case, async: true
alias PhoenixNotesApp.Repo
alias PhoenixNotesApp.Notes.Note
alias PhoenixNotesApp.Users.User

  defp note_fixture(attrs \\ %{})do
    {:ok, note} =
      attrs
      |> Enum.into(%{
        title: "Plans for today",
        content: "Meditate and relax"
      })

    |> PhoenixNotesApp.Notes.create_note()
    note
  end

  describe "create_note/1" do
    test "Insert note to user with complete data" do
      user = %User{username: "Alice", email: "alice@example.com", hashed_password: "secret"} |> Repo.insert!()

      note1 = %Note{title: "Note 1", content: "Content 1", user_id: user.id} |> Repo.insert!()
      note2 = %Note{title: "Note 2", content: "Content 2", user_id: user.id} |> Repo.insert!()
      note3 = %Note{title: "Note 3", content: "Content 3", user_id: user.id} |> Repo.insert!()

      notes = Repo.all(from n in Note, where: n.user_id == ^user.id, order_by: n.id)
      assert Enum.map(notes, & &1.id) == [note1.id, note2.id, note3.id]
      assert Enum.all?(notes, &(&1.user_id == user.id))
    end

    test "Insert note to user with incomplete credentials" do
      user = %User{username: "Alice", email: "alice@example.com", hashed_password: "secret"} |> Repo.insert!()

      note1 = %Note{title: "Note 1", content: "Content 1", user_id: user.id} |> Repo.insert!()
      note2 = %Note{title: "Note 2", user_id: user.id} |> Repo.insert!()
      note3 = %Note{title: "Note 3", content: "Content 3", user_id: user.id} |> Repo.insert!()

      notes = Repo.all(from n in Note, where: n.user_id == ^user.id, order_by: n.id)
      assert Enum.map(notes, & &1.id) == [note1.id, note2.id, note3.id]
      assert Enum.all?(notes, &(&1.user_id == user.id))

      note2_db = Repo.get!(Note, note2.id)
      assert is_nil(note2_db.content)
    end
  end


  describe "changeset/2" do
    test "Test Valid Changeset" do
      changeset = Note.changeset(%Note{}, %{id: 1, title: "Test Title", content: "Hello Mabuhay World", user_id: 1})
      assert changeset.valid?
    end

    test "Invalid Changeset, missing title" do
      changeset = Note.changeset(%Note{}, %{content: "Hello Mabuhay World", user_id: 1})
      refute changeset.valid?
    end

    test "Invalid Changeset, missing content" do
      changeset = Note.changeset(%Note{}, %{title: "Test Title", user_id: 1})
      refute changeset.valid?
    end

    test "Invalid Changeset, missing user_id" do
      changeset = Note.changeset(%Note{}, %{id: 1, title: "Test Title", content: "Hello Mabuhay World"})
      refute changeset.valid?
    end
  end

end
