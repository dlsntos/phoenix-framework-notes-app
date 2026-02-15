defmodule PhoenixNotesApp.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  @moduledoc """
  User

  ## Purpose
  This module contains the schema of the users table

  ## Fields
  - `":username"` - represents the user's username
  - `":email"` - represents the user's email
  - `":hashed_password" - - represents the user's password`

  """
  schema "users" do
    field :username, :string
    field :email, :string
    field :hashed_password, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :hashed_password])
    |> validate_required([:username, :email, :hashed_password])
    |> validate_format(:email, ~r/@/, message: "Please enter a valid email")
  end
end
