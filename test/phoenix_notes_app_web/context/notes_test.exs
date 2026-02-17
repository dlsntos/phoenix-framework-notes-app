defmodule PhoenixNotesAppWeb.NotesTest do
use PhoenixNotesApp.DataCase, async: true
use ExUnit.Case, async: true
alias PhoenixNotesAppWeb.HelperTest
alias PhoenixNotesApp.Repo
alias PhoenixNotesApp.Notes
alias PhoenixNotesApp.Notes.Note
alias PhoenixNotesApp.Users.User

  describe "delete_note/1" do
    test "Delete note by note_id" do
      user = HelperTest.user_fixture()
      note = HelperTest.note_fixture(%{user_id: user.id})

      assert {:ok, %Note{}} = Notes.delete_note(note.id)
      assert Notes.get_all_notes_by_userid(note.user_id) == []
    end

    test "Delete note by id but note_id does not exist" do
        nonexistent_note_id = -1

        assert {:error, :not_found} = Notes.delete_note(nonexistent_note_id)
    end
  end

  describe "update_note/2" do
    test "Update note all values" do
      user = HelperTest.user_fixture()
      note = HelperTest.note_fixture(%{user_id: user.id})

      {:ok, updated} = Notes.update_note(note, %{title: "Plans for tommorow", content: "Go Hiking"})
      assert updated.title == "Plans for tommorow"
      assert updated.content == "Go Hiking"
    end

    test "Update note single value" do
      user = HelperTest.user_fixture()
      note = HelperTest.note_fixture(%{user_id: user.id})

      {:ok, updated} = Notes.update_note(note, %{title: "Plans for tommorow"})
      assert updated.title == "Plans for tommorow"
    end

    test "Update note without changes" do
      user = HelperTest.user_fixture()
      note = HelperTest.note_fixture(%{user_id: user.id})

      {:ok, updated} = Notes.update_note(note, %{})
      assert updated.id == note.id
      assert updated.title == note.title
      assert updated.content == note.content
    end

    test "Update note blank values" do
      user = HelperTest.user_fixture()
      note = HelperTest.note_fixture(%{user_id: user.id})

      {:error, updated} = Notes.update_note(note, %{title: nil})
      assert "can't be blank" in errors_on(updated).title
    end

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
