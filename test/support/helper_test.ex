defmodule PhoenixNotesAppWeb.HelperTest do
alias PhoenixNotesApp.Notes
alias PhoenixNotesApp.Users

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        "username" => "test user",
        "email" => "iex@example.com",
        "hashed_password" => "secret"
      })
      |> Users.create_user()

    user
  end

  def note_fixture(attrs \\ %{})do
    {:ok, note} =
      attrs
      |> Enum.into(%{
        title: "Plans for today",
        content: "Meditate and relax"
      })

    |> Notes.create_note()
    note
  end
end
