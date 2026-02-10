defmodule PhoenixNotesApp.Notes do
  import Ecto.{Query, Schema}, warn: false
  alias PhoenixNotesApp.Repo
  alias PhoenixNotesApp.Notes.Note

  def change_note(%Note{} = note, attrs \\ %{}) do
    Note.changeset(note, attrs)
  end

  def get_all_notes_by_userid(user_id) do
    query = from n in Note,
          where: n.user_id == ^user_id
    Repo.all(query)
  end

  def get_note_by_id(id) do
    Repo.get_by(Note, id: id)
  end

  def delete_note(id) do
    note = get_note_by_id(id)

    case note do
      nil -> {:error, :not_found}
      note -> Repo.delete(note)
    end
  end

  def update_note(%Note{} = note, attrs) do
    note
    |> Note.changeset(attrs)
    |> Repo.update()
  end

  def create_note(attrs \\ %{}) do
    %Note{}

    |> Note.changeset(attrs)
    |> Repo.insert()
  end

end
