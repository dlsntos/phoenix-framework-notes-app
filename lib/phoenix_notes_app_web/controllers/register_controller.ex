defmodule PhoenixNotesAppWeb.RegisterController do
  use PhoenixNotesAppWeb, :controller

  def register(conn, _params) do
    render(conn, :register, layout: false)
  end
end
