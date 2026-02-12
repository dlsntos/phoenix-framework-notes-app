defmodule PhoenixNotesApp.Notes do
  import Ecto.{Query, Schema}, warn: false
  alias PhoenixNotesApp.Repo
  alias PhoenixNotesApp.Notes.Note

  @doc """
  Notes Context

  ## Purpose
  The Notes context contains the queries responsible for filtering, retrieving, creating, updating, and deleting notes.
  """

  @doc """
  Builds a changeset for a note with the given attributes.
  """
  def change_note(%Note{} = note, attrs \\ %{}) do
    Note.changeset(note, attrs)
  end

  @doc """
  Filter notes by user_id and title
  """
  def search_notes_by_title(user_id, query) do
    pattern = "%#{query}%"

    from(n in Note,
      where: n.user_id == ^user_id and ilike(n.title, ^pattern),
      order_by: [desc: n.inserted_at]
    )
    |> Repo.all()
  end

  @doc """
  Fetches all notes owned by a specific user_id
  """
  def get_all_notes_by_userid(user_id) do
    query = from n in Note,
          where: n.user_id == ^user_id
    Repo.all(query)
  end

  @doc """
  Fetches a note by note_id
  """
  def get_note_by_id(id) do
    Repo.get_by(Note, id: id)
  end

  @doc """
  Deletes a note by note_id
  """
  def delete_note(id) do
    note = get_note_by_id(id)

    case note do
      nil -> {:error, :not_found}
      note -> Repo.delete(note)
    end
  end

  @doc """
  Updates an existing note
  """
  def update_note(%Note{} = note, attrs) do
    note
    |> Note.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Creates a new note
  """
  def create_note(attrs \\ %{}) do
    %Note{}

    |> Note.changeset(attrs)
    |> Repo.insert()
  end

end
