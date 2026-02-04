defmodule PhoenixNotesAppWeb.ViewNoteComponent do
  use PhoenixNotesAppWeb, :live_component
  # def mount(_params, _session, socket) do

  # end

  def render(assigns) do
  ~H"""
    <div id="view-note-component">
      <.view_note />
    </div>
  """
  end
  embed_templates "layouts/view_note_html/*"
end
