defmodule PhoenixNotesAppWeb.LoginController do
  use PhoenixNotesAppWeb, :controller
  import Phoenix.Component
  alias PhoenixNotesApp.Users
  alias PhoenixNotesApp.Users.User

  @moduledoc """
  LoginController

  The Login controller module handles the
  user login related actions
  """

  @doc" Renders the login page"
  def login(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, :login, form: to_form(changeset),layout: false)
  end

  @doc"handles the user login logic"
  def create(conn, %{"user" => user_params}) do
    case Users.authenticate_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: ~p"/notes")

      {:error, _reason} ->
        changeset =
          %User{}
          |> Users.change_user(user_params)
          |> Map.put(:action, :insert)

        conn
        |> put_flash(:error, "Invalid email or password")
        |> render(:login, form: to_form(changeset), layout: false)
    end
  end

  @doc"handles the logout logic"
  def logout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: ~p"/login")
  end
end
