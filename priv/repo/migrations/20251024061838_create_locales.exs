defmodule TodoDesktopapp.Repo.Migrations.CreateLocales do
  use Ecto.Migration

  def change do
    create table(:locales, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :language, :string

      timestamps(type: :utc_datetime)
    end
  end
end
