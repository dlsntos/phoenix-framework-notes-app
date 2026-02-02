defmodule PhoenixNotesApp.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_notes_app,
    adapter: Ecto.Adapters.Postgres
end
