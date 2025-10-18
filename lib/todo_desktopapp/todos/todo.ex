defmodule TodoDesktopapp.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "todos" do
    field :title, :string
    field :description, :string
    field :done, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @min_chars 3
  @max_chars 25

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :description, :done])
    |> validate_required([:title, :description, :done])
    |> validate_length(:title, min: @min_chars, max: @max_chars)
  end
end

# COMMANDS:
# mix phx.gen.context Todos Todo todos title:string description:string done:boolean
# mix ecto.migrate

# REFERENCES:
# https://elixirforum.com/t/defining-ecto-schemas-postgres-to-use-not-null-in-column-definitions/14696/3
