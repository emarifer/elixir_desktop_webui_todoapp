defmodule TodoDesktopapp.MenuBar do
  @moduledoc """
    Menubar that is shown as part of the main Window on Windows/Linux. In
    MacOS this Menubar appears at the very top of the screen.
  """
  use Desktop.Menu
  # use Gettext, backend: TodoDesktopappWeb.Gettext

  alias Desktop.Window

  # @topic "language"

  @impl true
  def render(assigns) do
    ~H"""
    <menubar>
      <menu label="File">
        <item onclick="quit">Quit</item>
      </menu>
      <menu label="Extra">
        <item onclick="notification">Show Notification</item>
        <item onclick="browser">Open Browser</item>
      </menu>
      <menu label="Language">
        <item onclick="english">English</item>
        <item onclick="spanish">Spanish</item>
      </menu>
    </menubar>
    """
  end

  @impl true
  def mount(menu) do
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
      "Notification from Todolist WebUI Desktopapp!",
      id: :click,
      type: :info,
      timeout: 300
    )

    {:noreply, menu}
  end

  def handle_event("browser", menu) do
    Window.prepare_url(TodoDesktopappWeb.Endpoint.url())
    |> :wx_misc.launchDefaultBrowser()

    {:noreply, menu}
  end

  @impl true
  def handle_info(:changed, menu) do
    {:noreply, menu}
  end
end

# GETTEXT - LOCALES:
# mix gettext.extract
# mix gettext.merge priv/gettext
