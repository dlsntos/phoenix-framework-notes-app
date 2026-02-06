defmodule PhoenixNotesAppWeb.UserAuth do
  import Phoenix.Component
  alias PhoenixNotesApp.Users

  @doc """
  LiveView on_mount hook that loads the session and current user.
  It assigns `:session` and `:current_user` to the socket assigns.
  """
  def on_mount(:default, _params, session, socket) do
    socket = assign(socket, :session, session)

    case session["user_id"] do
      nil ->
        {:cont, assign(socket, :current_user, nil)}

      user_id ->
        case Users.get_user(user_id) do
          nil -> {:cont, assign(socket, :current_user, nil)}
          user -> {:cont, assign(socket, :current_user, user)}
        end
    end
  end
end
