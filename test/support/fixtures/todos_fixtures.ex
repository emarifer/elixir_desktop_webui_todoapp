defmodule TodoDesktopapp.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoDesktopapp.Todos` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        description: "some description",
        done: true,
        title: "some title"
      })
      |> TodoDesktopapp.Todos.create_todo()

    todo
  end
end
