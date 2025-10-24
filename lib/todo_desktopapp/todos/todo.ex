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
# mix phx.gen.context Locales Locale locales language:string
# mix ecto.migrate

# REFERENCES:
# https://elixirforum.com/t/defining-ecto-schemas-postgres-to-use-not-null-in-column-definitions/14696/3

# INSERT FROM IEX:
#
# iex(7)> Todo.changeset(%Todo{}, %{title: "Tarea n°1", description: "Descripción de la primera tarea"}) |> Repo.insert ==>
# [debug] QUERY OK source="todos" db=56.0ms decode=2.8ms idle=1103.9ms
# INSERT INTO "todos" ("done","description","title","inserted_at","updated_at","id") VALUES (?1,?2,?3,?4,?5,?6) [false, "Descripción de la primera tarea", "Tarea n°1", ~U[2025-10-19 17:48:51Z], ~U[2025-10-19 17:48:51Z], "1519d91d-351a-4aab-9d16-ab62e8f665d5"]
# ↳ :elixir.eval_external_handler/3, at: src/elixir.erl:386
# {:ok,
#  %TodoDesktopapp.Todos.Todo{
#    __meta__: #Ecto.Schema.Metadata<:loaded, "todos">,
#    id: "1519d91d-351a-4aab-9d16-ab62e8f665d5",
#    title: "Tarea n°1",
#    description: "Descripción de la primera tarea",
#    done: false,
#    inserted_at: ~U[2025-10-19 17:48:51Z],
#    updated_at: ~U[2025-10-19 17:48:51Z]
#  }}
