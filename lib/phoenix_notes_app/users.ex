defmodule PhoenixNotesApp.Users do
  import Ecto.Query, warn: false
  alias PhoenixNotesApp.Repo
  alias PhoenixNotesApp.Users.User

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  defp get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def authenticate_user(%{"email" => email, "password" => password}) do
    case get_user_by_email(email) do
      nil ->
        {:error, :invalid_credentials}

      user ->
        if user.hashed_password == password do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end
end
