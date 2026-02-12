defmodule PhoenixNotesAppWeb.RegisterController do
  use PhoenixNotesAppWeb, :controller
  import Phoenix.Component
  alias PhoenixNotesApp.Users
  alias PhoenixNotesApp.Users.User

  @moduledoc """
  The Register controller handles the user registration related logic
  """

  @doc"Renders the user registration page"
  def register(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, :register, form: to_form(changeset),layout: false)
  end

  # @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()

  @doc"Handles the user registration logic"
  def create(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully")
        |> redirect(to: ~p"/login")

      {:error, changeset} ->
      render(conn, :register, form: to_form(changeset), layout: false)
    end
  end
end
