defmodule TodoDesktopappWeb.TodoItemComponent do
  use TodoDesktopappWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <li
      phx-value-todo_id={"todo_id-#{@todo.id}"}
      class="flex justify-between items-center hover:bg-zinc-700 rounded-t-lg p-2 border-b border-slate-700 w-full"
    >
      <div>
        <div class="flex justify-start gap-2 items-center mb-2">
          <input type="checkbox" class="checkbox checkbox-success w-3.5 h-3.5" />
          <p class="text-xs text-zinc-300 hover:underline">{@todo.title}</p>
        </div>
        <p class="text-lime-400 text-[10px] font-mono overflow-hidden">
          {convert_datetime(@todo.updated_at)}
        </p>
      </div>
      <div class="flex justify-start items-center gap-3 w-fit">
        <button
          phx-value-id={@todo.id}
          data-confirm={"Are you sure you want to delete this Todo with title \"#{@todo.title}\"?"}
          phx-click="remove"
          title="Delete Todo"
          class="btn btn-circle btn-outline btn-xs btn-ghost text-[10px]"
        >
          ❌
        </button>
        <button title="Edit Todo" class="btn btn-circle btn-outline btn-xs btn-ghost text-[10px]">
          📝
        </button>
      </div>
    </li>
    """
  end

  def convert_datetime(dt) do
    tzone = Timex.Timezone.Local.lookup()

    {:ok, local_datetime} =
      Timex.to_datetime(dt, tzone) |> Timex.Format.DateTime.Formatter.format("{RFC1123}")

    local_datetime
  end
end
