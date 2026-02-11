defmodule PhoenixNotesAppWeb.Helpers.LiveViewHelper do
  def notify_parent(socket, message) do
    send(self(), {__MODULE__, message})
    socket
  end
end
