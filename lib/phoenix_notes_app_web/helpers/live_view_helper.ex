defmodule PhoenixNotesAppWeb.Helpers.LiveViewHelper do
  def notify_parent(socket, module, message) when is_atom(module) do
    send(self(), {module, message})
    socket
  end
end
