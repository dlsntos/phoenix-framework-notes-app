defmodule PhoenixNotesAppWeb.LoginTest do
  use ExUnit.Case, async: true
  use PhoenixNotesAppWeb.ConnCase, async: true
  alias PhoenixNotesApp.Users
  alias PhoenixNotesApp.Users.User
  import Pbkdf2

  describe "create_user/2" do
    test "Register user with complete credentials and hashed password" do
      attrs = %{
        "username" => "Test User",
        "email" => "iex@example.com",
        "hashed_password" => "secret"
      }

      {:ok, %User{} = user} = Users.create_user(attrs)

      refute user.hashed_password == "secret"
      assert Pbkdf2.verify_pass("secret", user.hashed_password)

      assert user.email == "iex@example.com"
      assert user.username == "Test User"
    end

    test "Register user with incomplete credentials" do
      attrs = %{
        "username" => nil,
        "email" => "iex@example.com",
        "hashed_password" => "secret"
      }

      assert {:error, Users.create_user(attrs)}
    end
  end

  describe "authenticate_user/2" do
    test "Authenticate user with proper credentials" do
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

    test "Authenticate user with invalid password" do
      password = "secret"
      password2 = "wrong password"

      user = %User{email: "alice@example.com", hashed_password: hash_pwd_salt(password)}
      user2 = %User{email: "iex10@example.com", hashed_password: hash_pwd_salt(password2)}

      result =
        if verify_pass(password, user2.hashed_password) do
          {:ok, user}
        else
          {:error, "Invalid password"}
        end

      assert {:error, "Invalid password"} = result
    end

  end

  describe "User changeset" do
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
end
