defmodule PhoenixNotesAppWeb.LoginTest do
  use ExUnit.Case, async: true
  alias PhoenixNotesApp.Users.User
  import Pbkdf2

  test "Test login" do
    password = "secret"
    user = %User{email: "alice@example.com", hashed_password: hash_pwd_salt(password)}

    result =
      if verify_pass(password, user.hashed_password) do
        {:ok, user}
      else
        {:error, "Invalid password"}
      end

    assert {:ok, ^user} = result

  end

  test "Test valid changeset" do
    changeset = User.changeset(%User{}, %{username: "Test user", email: "iex@example.com", hashed_password: "secret"})
    assert changeset.valid?
  end

  test "Test invalid changeset without username" do
    changeset = User.changeset(%User{}, %{email: "iex@example.com", hashed_password: "secret"})
    refute changeset.valid?
  end

  test "Test invalid changeset without email" do
    changeset = User.changeset(%User{}, %{username: "Test user", hashed_password: "secret"})
    refute changeset.valid?
  end

  test "Test invalid changeset without password" do
    changeset = User.changeset(%User{}, %{username: "Test user", email: "iex@example.com"})
    refute changeset.valid?
  end
end
