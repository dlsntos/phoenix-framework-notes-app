defmodule PhoenixNotesApp.Repo.Migrations.ChangeNotesContentToText do
  use Ecto.Migration

  def change do
    alter table(:notes) do
      modify :content, :text
    end
  end
end
