defmodule TodoDesktopappWeb.HomeLive do
  use TodoDesktopappWeb, :live_view
  use Gettext, backend: TodoDesktopappWeb.Gettext

  alias TodoDesktopapp.Todos
  alias TodoDesktopappWeb.TodoItemComponent

  import TodoDesktopappWeb.Utils.{GenerateAboutModal, HandleBackup}

  @impl true
  def render(assigns) do
    ~H"""
    <section
      class="transition-all duration-[1000ms] opacity-0 -translate-x-16"
      phx-mounted={JS.remove_class("opacity-0 -translate-x-16")}
    >
      <Layouts.flash_group flash={@flash} />

      <div class="flex flex-col pt-10 sm:pt-20 justify-center text-center gap-6 sm:gap-12 mx-auto w-fit px-12 sm:px-48">
        <div class="absolute top-2 left-2">
          <Layouts.theme_toggle />
        </div>
        <div class="w-80 sm:w-96 flex gap-6 items-center justify-center">
          <h1 class="text-3xl sm:text-4xl text-zinc-500 font-bold">
            {gettext("Todo List")}
          </h1>
          <img src="images/logo.png" alt="Logo" class="w-8 sm:w-12" />
        </div>

        <%!-- ↓↓ id={@form_id} ↓↓--%>
        <.form
          phx-submit="search"
          for={@form}
          class="flex justify-between items-center"
        >
          <label
            :if={length(@todos) > 1}
            class="input input-xs sm:input-sm flex items-center-safe w-[264px] px-1"
          >
            <svg
              class="h-[1em] opacity-50"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
            >
              <g
                stroke-linejoin="round"
                stroke-linecap="round"
                stroke-width="2.5"
                fill="none"
                stroke="currentColor"
              >
                <circle cx="11" cy="11" r="8"></circle>
                <path d="m21 21-4.3-4.3"></path>
              </g>
            </svg>
            <.input
              type="search"
              id="search_form"
              field={@form[:search]}
              class="w-56 text-[9px] -translate-y-[5px] sm:translate-y-0 sm:text-xs"
              placeholder={gettext("Search Todo ...")}
              phx-hook=".ClearSearchInput"
            />
            <%!-- ↓↓↓ Web app only. Not for desktop app ↓↓↓ --%>
            <script
              :type={Phoenix.LiveView.ColocatedHook}
              name=".ClearSearchInput"
            >
              export default {
                mounted() {
                  this.el.addEventListener("search", () => {
                    if (this.el.value == "") this.pushEvent("reset-search", {})
                  })
                }
              }
            </script>
          </label>
          <button
            :if={!@search}
            phx-click="delete_marked"
            type="button"
            title={gettext("Delete Marked")}
            class="btn btn-xs sm:btn-sm btn-outline btn-ghost border-slate-500 px-1.5"
            data-title={gettext("Confirm")}
            data-confirm={gettext("Are you sure you want to delete all the marked Todos?")}
            data-ok={gettext("Yes, delete them")}
            data-cancel={gettext("Cancel")}
          >
            <img src="images/bulk-delete.png" alt="Bulk Delete" class="w-6" />
          </button>
          <button
            :if={@search}
            type="reset"
            title={gettext("Exit Search")}
            class="btn btn-xs sm:btn-sm btn-outline btn-info flex items-center gap-1 w-fit px-1"
            phx-click="reset-search"
          >
            <.icon class="bg-slate-400 w-4 mt-1" name="hero-arrow-uturn-left" />
            <span class="hidden sm:block">{gettext("Exit Search")}</span>
          </button>
        </.form>

        <div class="flex flex-col gap-12">
          <ul class="w-full flex flex-col gap-2 overflow-y-auto max-h-64 scroller pr-2">
            <.live_component
              :for={todo <- @todos}
              module={TodoItemComponent}
              id={todo.id}
              todo={todo}
            />
          </ul>

          <p :if={length(@todos) == 0} class="text-sm font-light text-lime-400">
            {gettext("There are no Todos to display")}
          </p>

          <form
            :if={!@search}
            phx-submit="add"
            class="flex flex-col gap-2.5 sm:gap-4 px-8 w-full -mt-6 sm:mt-0"
          >
            <input
              type="text"
              class="input input-xs sm:input-sm w-full"
              name="title"
              placeholder={gettext("Title ...")}
              required
              autofocus
            />
            <input
              type="text"
              class="input input-xs sm:input-sm w-full"
              name="description"
              placeholder={gettext("Description ...")}
              required
            />
            <div class="flex justify-end">
              <button type="submit" class="btn btn-ghost btn-xs sm:btn-sm btn-outline">
                {gettext("Create")}
              </button>
            </div>
          </form>
        </div>
      </div>
    </section>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    TodoDesktopapp.MenuBar.subscribe()

    # IO.inspect(Application.get_env(:todo_desktopapp, :pass_zip), label: "PASS_ZIP")

    {:ok, init_search_form(socket)}
  end

  @impl true
  def handle_info({:backup, path}, socket) do
    case generate_backup(path) do
      {res, 0} when is_binary(res) ->
        socket = put_flash(socket, :info, gettext("The backup was successful!"))
        {:noreply, socket}

      {err, _} ->
        socket = put_flash(socket, :error, err)
        {:noreply, socket}
    end
  end

  def handle_info({:restore, path}, socket) do
    case restore_backup(path) do
      {res, 0} when is_binary(res) ->
        handle_locales()
        socket = put_flash(socket, :info, gettext("The backup has been restored successfully!"))
        {:noreply, socket |> push_navigate(to: ~p"/")}

      {err, _} ->
        handle_locales()

        socket = put_flash(socket, :error, err)
        {:noreply, socket}
    end
  end

  def handle_info(:about, socket) do
    {:noreply, push_event(socket, "about", %{html: html_about()})}
  end

  @impl true
  def handle_info(:english, socket) do
    # Gettext.put_locale("en")
    {:noreply, push_navigate(socket, to: ~p"/")}
  end

  @impl true
  def handle_info(:spanish, socket) do
    # Gettext.put_locale("es_ES")
    {:noreply, push_navigate(socket, to: ~p"/")}
  end

  @impl true
  def handle_event("search", params, socket) do
    case params do
      %{"search" => ""} ->
        {:noreply, socket}

      %{"search" => search} ->
        {:noreply, push_patch(socket, to: ~p"/?#{[search: search]}")}
    end
  end

  def handle_event("reset-search", _params, socket) do
    {:noreply,
     socket
     |> init_search_form()
     |> push_patch(to: ~p"/")}
  end

  def handle_event(
        "add",
        %{"description" => _description, "title" => _title} = unsigned_params,
        socket
      ) do
    case Todos.create_todo(unsigned_params) do
      {:ok, result} ->
        socket = put_flash(socket, :info, gettext("Todo created successfully!"))
        {:noreply, assign(socket, :todos, [result | socket.assigns[:todos]])}

      {:error, changeset_err} ->
        %{title: [msg]} =
          Ecto.Changeset.traverse_errors(changeset_err, fn {msg, opts} ->
            msg = translate_error(msg, opts)

            Enum.reduce(opts, msg, fn {key, value}, acc ->
              String.replace(acc, "%{#{key}}", to_string(value))
            end)
          end)

        {:noreply, put_flash(socket, :error, "#{gettext("Title:")} #{msg}")}
    end
  end

  def handle_event("remove", %{"id" => id}, socket) do
    case Todos.delete_todo(id) do
      {:ok, _} ->
        {:noreply,
         put_flash(socket, :info, gettext("Todo successfully deleted!"))
         |> assign(:todos, remove_item(socket.assigns[:todos], id))}

      _ ->
        {:noreply,
         put_flash(socket, :error, gettext("Error deleting Todo!"))
         |> assign(:todos, remove_item(socket.assigns[:todos], id))}
    end
  end

  def handle_event("delete_marked", _unsigned_params, socket) do
    case Todos.delete_marked() do
      {:ok, _} ->
        {:noreply,
         put_flash(socket, :info, gettext("Bulk delete successfully performed!"))
         |> assign(:todos, remove_marked(socket.assigns[:todos]))}

      _ ->
        {:noreply, put_flash(socket, :error, gettext("Error deleting Todo!"))}
    end
  end

  @impl true
  def handle_params(params, _uri, socket) do
    search =
      case params do
        %{"search" => _search} -> true
        _ -> nil
      end

    # Avoid 2 requests to the database when the component is mounted.
    # See below for details on whether or not to double-request the DB.
    if connected?(socket) do
      todos = Todos.search_todos_by_name(params)

      {:noreply,
       socket
       |> assign(:todos, todos)
       |> assign(:search, search)}
    else
      {:noreply, assign(socket, :todos, [])}
    end
  end

  defp translate_error(msg, opts) do
    case opts[:count] do
      nil -> Gettext.dgettext(TodoDesktopappWeb.Gettext, "errors", msg)
      count -> Gettext.dngettext(TodoDesktopappWeb.Gettext, "errors", msg, msg, count)
    end
  end

  defp init_search_form(socket) do
    socket
    |> assign(
      form: to_form(%{"search" => ""}),
      # form_id: "form-#{System.unique_integer()}",
      search: nil
    )
  end

  defp remove_item(todo_list, id) do
    Enum.reject(todo_list, &(&1.id == id))
  end

  defp remove_marked(todo_list) do
    Enum.reject(todo_list, &(&1.done == true))
  end
end

# REFERENCES:
# Translate Ecto validation messages ==>
# https://stackoverflow.com/questions/44183906/translate-ecto-validation-messages#53120162
# USING `GETTEXT` (Domains, Pluralization, etc.) ==>
# https://hexdocs.pm/gettext/Gettext.html#module-domains
# https://hexdocs.pm/gettext/Gettext.html#module-pluralization
# https://hexdocs.pm/gettext/Gettext.html#dngettext/6
# https://hexdocs.pm/gettext/Gettext.html#dgettext/4
#
# ABOUT THE COLOCATED HOOKS ==>
# https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.ColocatedHook.html

# Trouble resetting a LiveView form programmatically ==>
# https://elixirforum.com/t/trouble-resetting-a-liveview-form-programmatically/67532
# https://github.com/LostKobrakai/kobrakai_elixir/blob/main/lib/kobrakai_web/live/one_to_many_form.ex#L143-L152
#
# LIVEVIEW AND DATABASE QUERIES, DOES THIS RUN ONCE OR TWICE? ==>
# https://elixirforum.com/t/liveview-calls-mount-two-times/30519/4
# https://elixirforum.com/t/liveview-and-database-queries-does-this-run-once-or-twice/55050/8
# https://elixirforum.com/t/mount-vs-handle-params-on-the-liveview-life-cycle/31920/3
# https://kobrakai.de/kolumne/liveview-double-mount
# https://elixirforum.com/t/how-to-pass-data-from-the-assigns-in-the-first-mount-call-to-the-second-mount-in-liveview/62419

# GENERATE ZIP FILE WITH PASSWORD ==>
# pass = :crypto.strong_rand_bytes(32) |> Base.encode64 |> binary_part(0, 32)
# lWyC55doF16AvyvZpcX8Co+Y3ZYmWQEa
#
# System.cmd("/bin/sh", ["-c", "mkdir ~/Música/cmd-test"], stderr_to_stdout: true)
# System.cmd("/bin/sh", ["-c", "cp main.go tasks.csv ~/Música/cmd-test"], stderr_to_stdout: true)
# System.cmd("/bin/sh", ["-c", "zip -9rj ~/Música/cmd-test.zip ~/Música/cmd-test/*"], stderr_to_stdout: true)
# System.cmd("/bin/sh", ["-c", "zip -9rj -P #{pass} ~/Música/cmd-test.zip ~/Música/cmd-test/*"], stderr_to_stdout: true)
# System.cmd("/bin/sh", ["-c", "unzip ~/Música/cmd-test.zip -d ~/Vídeos"], stderr_to_stdout: true)
# System.cmd("/bin/sh", ["-c", "unzip -P #{pass} ~/Música/cmd-test.zip -d ~/Vídeos/cmd-test"], stderr_to_stdout: true)
# System.cmd("/bin/sh", ["-c", "unzip -P #{pass} ~/Música/cmd-test.zip -d /home"], stderr_to_stdout: true)
#
# https://askubuntu.com/questions/342900/compressing-folders-with-password-via-command-line
# https://stackoverflow.com/questions/9710141/create-zip-file-and-ignore-directory-structure
# https://stackoverflow.com/questions/41735442/phoenix-framework-generate-random-string-using-the-controller

# ==============================================================================

# OPTS: [count: 3, validation: :length, kind: :min, type: :string]
# MSG: "should be at least %{count} character(s)"
# KEY: :count
# VALUE: 3
# OPTS: [count: 3, validation: :length, kind: :min, type: :string]
# MSG: "should be at least %{count} character(s)"
# KEY: :validation
# VALUE: :length
# OPTS: [count: 3, validation: :length, kind: :min, type: :string]
# MSG: "should be at least %{count} character(s)"
# KEY: :kind
# VALUE: :min
# OPTS: [count: 3, validation: :length, kind: :min, type: :string]
# MSG: "should be at least %{count} character(s)"
# KEY: :type
# VALUE: :string

# OPTS: [count: 25, validation: :length, kind: :max, type: :string]
# MSG: "should be at most %{count} character(s)"
# KEY: :count
# VALUE: 25
# OPTS: [count: 25, validation: :length, kind: :max, type: :string]
# MSG: "should be at most %{count} character(s)"
# KEY: :validation
# VALUE: :length
# OPTS: [count: 25, validation: :length, kind: :max, type: :string]
# MSG: "should be at most %{count} character(s)"
# KEY: :kind
# VALUE: :max
# OPTS: [count: 25, validation: :length, kind: :max, type: :string]
# MSG: "should be at most %{count} character(s)"
# KEY: :type
# VALUE: :string

# CHANGESET_ERR: #Ecto.Changeset<
#   action: :insert,
#   changes: %{description: "JK", title: "JK"},
#   errors: [
#     title: {"should be at least %{count} character(s)",
#      [count: 3, validation: :length, kind: :min, type: :string]}
#   ],
#   data: #TodoDesktopapp.Todos.Todo<>,
#   valid?: false,
#   ...
# >
