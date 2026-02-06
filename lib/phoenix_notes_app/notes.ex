defmodule PhoenixNotesApp.Notes do
  import Ecto.Query, warn: false
  alias PhoenixNotesApp.Repo
  alias PhoenixNotesApp.Notes.Note

  def get_all_notes_by_userid(user_id) do
    Repo.all_by(Note, user_id)
  end

  def get_note_by_id(id) do
    Repo.get_by(Note, id)
  end

end
