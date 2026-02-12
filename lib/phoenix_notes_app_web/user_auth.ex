defmodule PhoenixNotesAppWeb.UserAuth do
  import Phoenix.Component
  alias PhoenixNotesApp.Users

  @doc """
  LiveView on_mount hook that loads the session and current user.
  It assigns `:session`, `:current_user`, and `:current_scope` to the socket assigns.
  """
  def on_mount(:default, _params, session, socket) do
    socket = assign(socket, :session, session)

    case session["user_id"] do
      nil ->
        {:cont, assign(socket, :current_user, current_scope: nil)}

      user_id ->
        case Users.get_user(user_id) do
          nil -> {:cont, assign(socket, current_user: nil, current_scope: nil)}
          user -> {:cont, assign(socket, current_user: user, current_scope: user)}
        end
    end
  end
end
