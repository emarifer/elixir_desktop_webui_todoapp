defmodule TodoDesktopapp.Todos do
  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, warn: false
  alias TodoDesktopapp.Repo

  alias TodoDesktopapp.Todos.Todo

  # @topic "todos"

  @doc """
  Returns the list of todos.

  ## Examples

      iex> list_todos()
      [%Todo{}, ...]

  """
  def list_todos do
    Todo
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def search_todos_by_name(params) do
    case params do
      %{"search" => search_term} ->
        Todo
        |> where(
          [t],
          like(t.title, ^"%#{search_term}%")
        )
        |> order_by(desc: :inserted_at)
        |> Repo.all()

      _ ->
        list_todos()
    end
  end

  @doc """
  Gets a single todo.

  Raises `Ecto.NoResultsError` if the Todo does not exist.

  ## Examples

      iex> get_todo!(123)
      %Todo{}

      iex> get_todo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_todo(id), do: Repo.get(Todo, id)

  @doc """
  Creates a todo.

  ## Examples

      iex> create_todo(%{field: value})
      {:ok, %Todo{}}

      iex> create_todo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo(attrs) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update_todo(todo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a todo.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Todo{}}

      iex> delete_todo(todo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo(id) do
    with %Todo{} = result <- Repo.get(Todo, id),
         {:ok, todo_deleted} <- Repo.delete(result) do
      {:ok, todo_deleted}
      # else
      #   nil -> nil
      #   {:error, err} -> {:error, err}
    end
  end

  # ↓↓↓ See REFERENCES below ↓↓↓
  def delete_marked do
    queryable = from(t in Todo, where: t.done == true)

    Ecto.Multi.new()
    |> Ecto.Multi.delete_all(:delete_all, queryable)
    |> Repo.transact()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> change_todo(todo)
      %Ecto.Changeset{data: %Todo{}}

  """
  def change_todo(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end

  def convert_datetime(dt) do
    tzone = Timex.Timezone.Local.lookup()

    {:ok, local_datetime} =
      Timex.to_datetime(dt, tzone) |> Timex.Format.DateTime.Formatter.format("{RFC1123}")

    local_datetime
  end

  # def subscribe do
  #   Phoenix.PubSub.subscribe(TodoDesktopapp.PubSub, @topic)
  # end
end

# REFERENCES:
# Ecto.Multi.delete_all/4 ==>
# https://hexdocs.pm/ecto/Ecto.Multi.html#delete_all/4
# https://elixirforum.com/t/ecto-delete-a-record-without-selecting-first/20024/3
