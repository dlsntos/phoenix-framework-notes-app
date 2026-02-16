defmodule PhoenixNotesAppWeb.LandingPageControllerTest do
  use PhoenixNotesAppWeb.ConnCase, async: true

  test "GET / render landing page", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200)
  end

end
