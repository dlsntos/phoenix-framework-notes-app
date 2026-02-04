defmodule PhoenixNotesAppWeb.CreateNoteComponent do
  use PhoenixNotesAppWeb, :live_component

  def render(assigns) do
    ~H"""
      <div id="create-note-component">
        <.create_note />
      </div>
    """
  end
  embed_templates "layouts/create_note_html/*"
end
