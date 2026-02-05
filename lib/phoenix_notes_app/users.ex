defmodule PhoenixNotesApp.Users do
  import Ecto.Query, warn: false
  alias PhoenixNotesApp.Repo
  alias PhoenixNotesApp.Users.User

  # Login function
  def login_user(username_or_email, password) do
    user =
      Repo.get_by(User, username: username_or_email) ||
      Repo.get_by(User, email: username_or_email)

    cond do
      user && user.haspass == password ->
        {:ok, user}

      user ->
        {:error, :invalid_password}

      true ->
        {:error, :user_not_found}
    end
  end
end
