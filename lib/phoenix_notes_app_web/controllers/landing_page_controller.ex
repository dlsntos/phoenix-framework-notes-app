defmodule PhoenixNotesAppWeb.NoteController do
  use PhoenixNotesAppWeb, :controller
  def index(conn, _params) do
    render(conn, :index, layout: false)
  end
end
