defmodule TodoDesktopapp.MenuBar do
  @moduledoc """
    Menubar that is shown as part of the main Window on Windows/Linux. In
    MacOS this Menubar appears at the very top of the screen.
  """
  use Desktop.Menu
  use Gettext, backend: TodoDesktopappWeb.Gettext

  alias Desktop.Window
  alias TodoDesktopapp.Locales

  @topic_m "modal"
  @topic_l "language"

  @impl true
  def render(assigns) do
    ~H"""
    <menubar>
      <menu label={gettext("File")}>
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
  def handle_event("quit", menu) do
    Window.quit()

    {:noreply, menu}
  end

  def handle_event("notification", menu) do
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
    {:noreply, menu}
  end

  def subscribe do
    Phoenix.PubSub.subscribe(TodoDesktopapp.PubSub, @topic_m)
    Phoenix.PubSub.subscribe(TodoDesktopapp.PubSub, @topic_l)
  end

  defp new_dom do
    {:menubar, %{"data-phx-loc": "18"},
     [
       {:menu, %{label: gettext("File"), "data-phx-loc": "19"},
        [{:item, %{onclick: "quit", "data-phx-loc": "20"}, [gettext("Quit")]}]},
       {:menu, %{label: gettext("Extra"), "data-phx-loc": "22"},
        [
          {:item, %{onclick: "notification", "data-phx-loc": "23"},
           [gettext("Show Notification")]},
          {:item, %{onclick: "about", "data-phx-loc": "24"}, [gettext("Open About")]}
        ]},
       {:menu, %{label: gettext("Language"), "data-phx-loc": "26"},
        [
          {:item, %{onclick: "english", "data-phx-loc": "27"}, [gettext("English")]},
          {:item, %{onclick: "spanish", "data-phx-loc": "28"}, [gettext("Spanish")]}
        ]}
     ]}
  end
end

# GETTEXT - LOCALES:
# mix gettext.extract
# mix gettext.merge priv/gettext
