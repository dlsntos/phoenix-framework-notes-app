defmodule PhoenixNotesAppWeb.ViewNoteLive do
  use PhoenixNotesAppWeb, :live_view
  def mount(_params, _session, socket) do
  {:ok, assign(socket, :brightness, 10)}
  end

  def render(assigns) do
  ~H"""
    <.view_note />
  """
  end
  embed_templates "layouts/view_note_html/*"
end
