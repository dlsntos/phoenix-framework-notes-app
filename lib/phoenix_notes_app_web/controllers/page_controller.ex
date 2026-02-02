defmodule PhoenixNotesAppWeb.PageController do
  use PhoenixNotesAppWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
