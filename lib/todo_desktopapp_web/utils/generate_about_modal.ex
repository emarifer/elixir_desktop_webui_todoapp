defmodule TodoDesktopappWeb.Utils.GenerateAboutModal do
  use Gettext, backend: TodoDesktopappWeb.Gettext

  def html_about do
    """
    <h1 class="text-2xl text-sky-600 font-bold">
      #{gettext("About")}
    </h1>

    <h3 class="text-sm font-medium text-amber-600 mt-6">
      #{gettext("Todolist WebUI Desktopapp is a simple task manager so you don't forget anything 😀")}
    </h3>
    <p class="text-slate-500 font-medium mt-4">
      #{gettext("More Info:")}
    </p>
    <a
      class="hover:text-sky-500 ease-in duration-300 text-sm"
      href="https://github.com/emarifer/elixir_desktop_webui_todoapp"
      target="_blank"
      rel="noopener noreferrer"
    >
      https://github.com/emarifer/elixir_desktop_webui_todoapp
    </a>

    <a href="https://github.com/emarifer?tab=repositories" target="_blank" rel="noopener noreferrer" class="block mt-4 text-[11px]">
        ⚡ #{gettext("Made by")} emarifer&nbsp;&nbsp;|&nbsp;&nbsp;Copyright © #{DateTime.utc_now() |> Map.fetch!(:year)} - #{gettext("MIT Licensed")}
    </a>
    """
  end
end
