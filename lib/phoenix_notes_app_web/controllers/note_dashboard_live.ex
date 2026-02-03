defmodule PhoenixNotesAppWeb.NoteDashboardLive do
  use PhoenixNotesAppWeb, :live_view
  def mount(_params, _session, socket) do
  {:ok, assign(socket, :brightness, 10)}
  end

  def render(assigns) do
  ~H"""
    <.dashboard />
  """
  end
  embed_templates "live/note_dashboard_html/*"
end
