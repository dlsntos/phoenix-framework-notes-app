defmodule PhoenixNotesAppWeb.NoteDashboardLive do
  use PhoenixNotesAppWeb, :live_view
  def mount(_params, _session, socket) do
    {:ok, assign(socket, show_modal: false)}
  end

  def handle_event("open-modal", _, socket) do
    {:noreply, assign(socket, show_modal: true)}
  end

  def handle_event("close-modal", _, socket) do
    {:noreply, assign(socket, show_modal: false)}
  end
  def render(assigns) do
  ~H"""
    <.dashboard show_modal={@show_modal}/>
  """
  end
  embed_templates "layouts/note_dashboard_html/*"
end
