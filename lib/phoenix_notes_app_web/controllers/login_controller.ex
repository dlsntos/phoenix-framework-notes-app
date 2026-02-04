defmodule PhoenixNotesAppWeb.LoginController do
  use PhoenixNotesAppWeb, :controller
  def login(conn, _params) do
    render(conn, :login, layout: false)
  end
end
