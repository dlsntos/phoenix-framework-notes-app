defmodule PhoenixNotesAppWeb.LandingPageController do
  use PhoenixNotesAppWeb, :controller

  @moduledoc """
  LandingPageController

  ## Purpose
  Responsible for rendering the Landing Page
  """
  def index(conn, _params) do
    render(conn, :index, layout: false)
  end
end
