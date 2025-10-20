defmodule TodoDesktopappWeb.HomeLive do
  use TodoDesktopappWeb, :live_view

  alias TodoDesktopapp.Todos
  alias TodoDesktopappWeb.TodoItemComponent

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.flash_group flash={@flash} />

    <section class="flex flex-col pt-20 justify-center text-center gap-12 mx-auto w-fit px-48">
      <div class="absolute top-2 left-2">
        <Layouts.theme_toggle />
      </div>
      <div class="w-96 flex gap-6 items-center justify-center">
        <h1 class="text-4xl text-zinc-500 font-bold">Todo List</h1>
        <img src="images/logo.png" alt="Logo" class="w-12" />
      </div>

      <div class="flex flex-col gap-12">
        <ul class="w-full flex flex-col gap-2 overflow-y-auto max-h-64 scroller">
          <.live_component :for={todo <- @todos} module={TodoItemComponent} id={todo.id} todo={todo} />
        </ul>

        <p :if={length(@todos) == 0} class="text-sm font-light text-lime-400">
          You don't have any Todo yet
        </p>

        <form phx-submit="add" class="flex flex-col gap-4 px-8 w-full">
          <input
            type="text"
            class="input input-sm w-full"
            name="title"
            placeholder="Title ..."
            required
            autofocus
          />
          <input
            type="text"
            class="input input-sm w-full"
            name="description"
            placeholder="Description ..."
            required
          />
          <div class="flex justify-end">
            <button type="submit" class="btn btn-ghost btn-sm btn-outline">Create</button>
          </div>
        </form>
      </div>
    </section>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    todos = Todos.list_todos()
    {:ok, assign(socket, :todos, todos)}
  end

  @impl true
  def handle_event(
        "add",
        %{"description" => _description, "title" => _title} = unsigned_params,
        socket
      ) do
    case Todos.create_todo(unsigned_params) do
      {:ok, result} ->
        # todos = Todos.list_todos()

        socket = put_flash(socket, :info, "Todo created successfully!")
        {:noreply, assign(socket, :todos, [result | socket.assigns[:todos]])}

      {:error, changeset_err} ->
        %{title: [msg]} =
          Ecto.Changeset.traverse_errors(changeset_err, fn {msg, opts} ->
            Enum.reduce(opts, msg, fn {key, value}, acc ->
              String.replace(acc, "%{#{key}}", to_string(value))
            end)
          end)

        {:noreply, put_flash(socket, :error, "Title: #{msg}")}
    end
  end

  def handle_event("remove", %{"id" => id}, socket) do
    case Todos.delete_todo(id) do
      {:ok, _} ->
        {:noreply,
         put_flash(socket, :info, "Todo successfully deleted!")
         |> assign(:todos, remove_item(socket.assigns[:todos], id))}

      _ ->
        {:noreply,
         put_flash(socket, :error, "Error deleting Todo!")
         |> assign(:todos, remove_item(socket.assigns[:todos], id))}
    end
  end

  defp remove_item(todo_list, id) do
    Enum.reject(todo_list, &(&1.id == id))
  end
end
