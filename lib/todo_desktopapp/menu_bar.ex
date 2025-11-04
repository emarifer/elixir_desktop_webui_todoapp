defmodule TodoDesktopapp.MenuBar do
  @moduledoc """
    Menubar that is shown as part of the main Window on Windows/Linux. In
    MacOS this Menubar appears at the very top of the screen.
  """
  use Desktop.Menu
  use Gettext, backend: TodoDesktopappWeb.Gettext

  alias Desktop.Window
  alias TodoDesktopapp.Locales

  @topic_b "backup"
  @topic_l "language"
  @topic_m "modal"
  @topic_r "restore"
  @topic_menu "restore_menubar"

  @impl true
  def render(assigns) do
    ~H"""
    <menubar>
      <menu label={gettext("File")}>
        <item onclick="backup">{gettext("Create Backup")}</item>
        <item onclick="restore">{gettext("Restore Backup")}</item>
        <hr />
        <item onclick="quit">{gettext("Quit")}</item>
      </menu>
      <menu label={gettext("Extra")}>
        <item onclick="notification">{gettext("Show Notification")}</item>
        <item onclick="about">{gettext("Open About")}</item>
      </menu>
      <menu label={gettext("Language")}>
        <item onclick="english">{gettext("English")}</item>
        <item onclick="spanish">{gettext("Spanish")}</item>
      </menu>
    </menubar>
    """
  end

  @impl true
  def mount(menu) do
    Phoenix.PubSub.subscribe(TodoDesktopapp.PubSub, @topic_menu)

    case Locales.list_locales() do
      [] ->
        Locales.create_locale(%{"language" => "en"})
        Desktop.put_default_locale("en")
        Window.set_title(TodoDesktopappWindow, gettext("Todolist WebUI Desktopapp"))

      [locale | _] ->
        Desktop.put_default_locale(locale.language)
        Window.set_title(TodoDesktopappWindow, gettext("Todolist WebUI Desktopapp"))
    end

    {:ok, menu}
  end

  @impl true
  def handle_event("backup", menu) do
    wx = :wx.new()
    dialog = :wxDirDialog.new(wx)
    :wxDirDialog.setTitle(dialog, gettext("Select the folder where you want to save the Backup"))
    :wxDirDialog.setPath(dialog, System.user_home())

    case :wxDirDialog.showModal(dialog) do
      5100 ->
        path =
          dialog
          |> :wxDirDialog.getPath()
          |> List.to_string()

        Phoenix.PubSub.broadcast(TodoDesktopapp.PubSub, @topic_b, {:backup, path})

      _ ->
        {:error, "cancelled"} |> IO.inspect(label: "SELECTED PATH")
    end

    {:noreply, menu}
  end

  def handle_event("restore", menu) do
    wx = :wx.new()
    dialog = :wxFileDialog.new(wx)
    :wxFileDialog.setTitle(dialog, gettext("Select your Backup *.zip file"))
    :wxFileDialog.setPath(dialog, System.user_home() <> "/*")

    :wxFileDialog.setWildcard(
      dialog,
      "#{gettext("Backup File")} (todo_desktopapp.zip)|todo_desktopapp.zip"
    )

    case :wxFileDialog.showModal(dialog) do
      5100 ->
        path =
          dialog
          |> :wxFileDialog.getPath()
          |> List.to_string()

        Phoenix.PubSub.broadcast(TodoDesktopapp.PubSub, @topic_r, {:restore, path})

      _ ->
        {:error, "cancelled"} |> IO.inspect(label: "SELECTED PATH")
    end

    {:noreply, menu}
  end

  def handle_event("quit", menu) do
    Window.quit()

    {:noreply, menu}
  end

  def handle_event("notification", menu) do
    IO.inspect(menu.dom, label: "DOM")

    Window.show_notification(
      TodoDesktopappWindow,
      gettext("Notification from Todolist WebUI Desktopapp!"),
      id: :click,
      type: :info,
      timeout: 300
    )

    {:noreply, menu}
  end

  def handle_event("about", menu) do
    Phoenix.PubSub.broadcast(TodoDesktopapp.PubSub, @topic_m, :about)

    {:noreply, menu}
  end

  def handle_event("english", menu) do
    Desktop.put_default_locale("en")
    language = Locales.get_locales!()
    Locales.update_locale(language, %{"language" => "en"})

    Phoenix.PubSub.broadcast(TodoDesktopapp.PubSub, @topic_l, :english)
    Window.set_title(TodoDesktopappWindow, gettext("Todolist WebUI Desktopapp"))

    {:noreply, assign(menu, dom: new_dom())}
  end

  def handle_event("spanish", menu) do
    Desktop.put_default_locale("es_ES")
    language = Locales.get_locales!()
    Locales.update_locale(language, %{"language" => "es_ES"})

    Phoenix.PubSub.broadcast(TodoDesktopapp.PubSub, @topic_l, :spanish)
    Window.set_title(TodoDesktopappWindow, gettext("Todolist WebUI Desktopapp"))

    {:noreply, assign(menu, dom: new_dom())}
  end

  @impl true
  def handle_info(:changed, menu) do
    Window.set_title(TodoDesktopappWindow, gettext("Todolist WebUI Desktopapp"))

    {:noreply, assign(menu, dom: new_dom())}
  end

  def subscribe do
    Phoenix.PubSub.subscribe(TodoDesktopapp.PubSub, @topic_b)
    Phoenix.PubSub.subscribe(TodoDesktopapp.PubSub, @topic_l)
    Phoenix.PubSub.subscribe(TodoDesktopapp.PubSub, @topic_m)
    Phoenix.PubSub.subscribe(TodoDesktopapp.PubSub, @topic_r)
  end

  defp new_dom do
    {:menubar, %{"data-phx-loc": "21"},
     [
       {:menu, %{label: gettext("File"), "data-phx-loc": "22"},
        [
          {:item, %{"data-phx-loc": "23", onclick: "backup"}, [gettext("Create Backup")]},
          {:item, %{"data-phx-loc": "24", onclick: "restore"}, [gettext("Restore Backup")]},
          {:hr, %{"data-phx-loc": "25"}, []},
          {:item, %{"data-phx-loc": "26", onclick: "quit"}, [gettext("Quit")]}
        ]},
       {:menu, %{label: gettext("Extra"), "data-phx-loc": "28"},
        [
          {:item, %{"data-phx-loc": "29", onclick: "notification"},
           [gettext("Show Notification")]},
          {:item, %{"data-phx-loc": "30", onclick: "about"}, [gettext("Open About")]}
        ]},
       {:menu, %{label: gettext("Language"), "data-phx-loc": "32"},
        [
          {:item, %{"data-phx-loc": "33", onclick: "english"}, [gettext("English")]},
          {:item, %{"data-phx-loc": "34", onclick: "spanish"}, [gettext("Spanish")]}
        ]}
     ]}
  end
end

# GETTEXT - LOCALES (COMMANDS):
# mix gettext.extract
# mix gettext.merge priv/gettext

# ==================================

# REFERENCES:
# https://hexdocs.pm/phoenix_pubsub/2.2.0/Phoenix.PubSub.html
# https://gist.github.com/rlipscombe/5f400451706efde62acbbd80700a6b7c
# https://github.com/julianferrone/seven_guis
# https://github.com/lawik/native-ui-sample
# https://github.com/kaiyote/ex_notepad/blob/0df1c3e9d56c9c4b6e9a3ca8a61e1e6c40e6a0b3/lib/ex_notepad/file.ex#L62
# https://www.erlang.org/doc/apps/wx/wxdirdialog
# https://www.erlang.org/doc/apps/wx/wxfiledialog
# https://arifishaq.wordpress.com/wp-content/uploads/2017/12/wxerlang-getting-started.pdf
