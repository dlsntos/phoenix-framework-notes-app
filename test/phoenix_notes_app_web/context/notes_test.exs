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
    test "Create new note with complete values" do
      user = HelperTest.user_fixture()

      attrs = %{
        title: "My Bucket List",
        content: "1. Build an MVP \n 2. Upskill on cloud computing \n 3. Travel to Japan",
        user_id: user.id
      }

      assert {:ok, Notes.create_note(attrs)}
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
