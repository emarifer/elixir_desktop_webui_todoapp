defmodule TodoDesktopappWeb.TodoItemComponent do
  use TodoDesktopappWeb, :live_component
  use Gettext, backend: TodoDesktopappWeb.Gettext

  alias TodoDesktopapp.Todos

  @impl true
  def render(assigns) do
    ~H"""
    <li
      phx-value-todo_id={"todo_id-#{@todo.id}"}
      class="flex justify-between items-center hover:bg-zinc-700 rounded-t-lg p-2 border-b border-slate-700 w-full"
    >
      <div>
        <div class="flex justify-start gap-2 items-center mb-2">
          <input
            type="checkbox"
            checked={@todo.done}
            class="checkbox checkbox-success w-3.5 h-3.5 pointer-events-none"
          />
          <p
            class={[
              "text-xs text-zinc-300",
              @todo.done && "line-through"
            ]}
            title={
              "#{gettext("• Title:")} #{@todo.title}\n#{gettext("• Description:")} #{@todo.description}"
              }
          >
            {@todo.title}
          </p>
        </div>
        <p class="text-lime-400 text-[10px] font-mono overflow-hidden">
          {Todos.convert_datetime(@todo.updated_at)}
        </p>
      </div>
      <div class="flex justify-start items-center gap-3 w-fit">
        <button
          phx-value-id={@todo.id}
          data-title={gettext("Confirm")}
          data-confirm={"#{gettext("Are you sure you want to delete this Todo with title")} \"#{@todo.title}\"?"}
          data-ok={gettext("Yes, delete it")}
          data-cancel={gettext("Cancel")}
          phx-click="remove"
          title={gettext("Delete Todo")}
          class="btn btn-circle btn-outline btn-xs btn-ghost text-[10px]"
        >
          ❌
        </button>
        <.link
          navigate={~p"/edit/#{@todo.id}"}
          title={gettext("Show/Edit Todo")}
          class="btn btn-circle btn-outline btn-xs btn-ghost text-[10px]"
        >
          📝
        </.link>
      </div>
    </li>
    """
  end
end

# REFERENCES: DAISYUI - TOOLTIP MULTILINE
# https://github.com/saadeghi/daisyui/issues/84#issuecomment-1429597264
# tooltip tooltip-right  before:whitespace-pre-wrap before:[--tw-content:'line1_\a_line2'
