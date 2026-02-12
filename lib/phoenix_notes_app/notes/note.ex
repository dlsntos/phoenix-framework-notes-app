defmodule PhoenixNotesApp.Notes.Note do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Note Schema

  ## Purpose
  This module contains the schema of the notes table

  ## Fields
  - `":title"` - represents the note title.
  - `":content"` - represents the note's content.
  - `":user_id"` - represents the user_id referenced from the users table.
  """
  schema "notes" do
    field :title, :string
    field :content, :string
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:title, :content, :user_id])
    |> validate_required([:title, :content, :user_id])
  end
end
