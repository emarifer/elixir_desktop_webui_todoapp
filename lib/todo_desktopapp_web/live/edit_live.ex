defmodule TodoDesktopappWeb.EditLive do
  use TodoDesktopappWeb, :live_view
  use Gettext, backend: TodoDesktopappWeb.Gettext

  alias TodoDesktopapp.Todos
  import TodoDesktopappWeb.Utils.GenerateAboutModal

  @impl true
  def render(assigns) do
    ~H"""
    <section
      class="transition-all duration-[1000ms] opacity-0 -translate-x-16"
      phx-mounted={JS.remove_class("opacity-0 -translate-x-16")}
    >
      <Layouts.flash_group flash={@flash} />

      <div class="flex flex-col pt-20 justify-center text-center gap-12 mx-auto w-fit">
        <h1 class="text-2xl text-zinc-500 font-bold">
          {gettext("Show/Edit Todo")} "{@todo_edit.title}"
        </h1>

        <form phx-submit="update" class="flex flex-col gap-4 px-8 w-[400px] mx-auto">
          <input
            type="text"
            class={["input input-sm text-xs font-light w-full pl-4", !@edit && "pointer-events-none"]}
            name="title"
            placeholder={gettext("Title ...")}
            value={@todo_edit.title}
            maxlength="25"
            minlength="3"
            required
            autofocus
          />
          <textarea
            name="description"
            placeholder={gettext("Description ...")}
            value={@todo_edit.description}
            required
            class={[
              "input text-xs font-light w-full text-wrap h-20 p-0.5 scroller",
              !@edit && "pointer-events-none"
            ]}
          >
          {@todo_edit.description}
        </textarea>
          <label class={[
            "flex justify-end text-xs font-light gap-2",
            !@edit && "pointer-events-none"
          ]}>
            {gettext("Status:")}
            <.input
              type="checkbox"
              name="done"
              checked={@todo_edit.done}
              class="checkbox checkbox-success w-3.5 h-3.5 -mt-2"
            />
          </label>
          <div class="flex justify-between">
            <button type="button" phx-click="toggle_edit" class="btn btn-ghost btn-sm btn-outline">
              {gettext("Toggle Edit")}
            </button>
            <div class="flex justify-end gap-3">
              <button type="submit" class="btn btn-success btn-sm btn-outline">
                {gettext("Update")}
              </button>

              <.link navigate={~p"/"} class="btn btn-sm btn-error btn-outline">
                {gettext("Cancel")}
              </.link>
            </div>
          </div>
        </form>
      </div>
    </section>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    TodoDesktopapp.MenuBar.subscribe()

    case Todos.get_todo(id) do
      nil ->
        {:ok, put_flash(socket, :error, "Error getting the Todo!")}

      todo ->
        {:ok, assign(socket, [{:todo_edit, todo}, {:edit, nil}])}
    end
  end

  @impl true
  def handle_info(:about, socket) do
    {:noreply, push_event(socket, "about", %{html: html_about()})}
  end

  @impl true
  def handle_info(:english, socket) do
    # Gettext.put_locale("en")

    id = socket.assigns.todo_edit.id
    {:noreply, push_navigate(socket, to: ~p"/edit/#{id}")}
  end

  @impl true
  def handle_info(:spanish, socket) do
    # Gettext.put_locale("es_ES")

    id = socket.assigns.todo_edit.id
    {:noreply, push_navigate(socket, to: ~p"/edit/#{id}")}
  end

  @impl true
  def handle_event("toggle_edit", _unsigned_params, socket) do
    if socket.assigns[:edit] do
      {:noreply, assign(socket, :edit, nil)}
    else
      {:noreply, assign(socket, :edit, true)}
    end
  end

  def handle_event(
        "update",
        %{
          "title" => title,
          "description" => description,
          "done" => done
        },
        socket
      ) do
    title = String.trim(title)
    description = String.trim(description)
    done = String.to_atom(done)
    todo = socket.assigns[:todo_edit]

    case Todos.update_todo(todo, %{"title" => title, "description" => description, "done" => done}) do
      {:ok, _} ->
        socket = put_flash(socket, :info, gettext("Todo updated successfully!"))
        {:noreply, push_navigate(socket, to: ~p"/")}

      {:error, _} ->
        socket = put_flash(socket, :error, gettext("Error updating Todo!"))
        {:noreply, push_navigate(socket, to: ~p"/")}
    end
  end
end
