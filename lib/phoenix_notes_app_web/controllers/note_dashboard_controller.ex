defmodule PhoenixNotesAppWeb.NoteDashboard do
  use PhoenixNotesAppWeb, :controller

  def dashboard(conn, _params) do
    render(conn, :dashboard, layout: false)
  end
end
