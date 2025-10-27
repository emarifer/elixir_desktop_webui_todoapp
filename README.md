<div align="center">

# Elixir Desktop WebUI Todoapp

#### Simple and Cross-Platform DesktopApp Demo built on Phoenix with native menus, notifications, and full English/Spanish translation

<br />

<img src="screenshot/screenshot_27-10-2025_09-40.gif" width="66%">

<br />
  
![GitHub License](https://img.shields.io/github/license/emarifer/elixir_desktop_webui_todoapp) ![Static Badge](https://img.shields.io/badge/Elixir-%3E=1.18-6e4a7e) ![Static Badge](https://img.shields.io/badge/Erlang/OTP-%3E=27-B83998) ![Static Badge](https://img.shields.io/badge/PhoenixFramework-%3E=1.8-fd4f00)

</div>

---

### 🚀 Features


> 🚧 This is a work-in-progress section of README.md. You'll see it finished soon.

---

### 👨‍🚀 Getting Started

- #### <ins>Installing/Using the application</ins>

  * **Prerequisites**: Obviously, you'll need to install [`Elixir`](https://elixir-lang.org/install.html) and [`Erlang/OTP`](https://www.erlang.org/) (because you'll need to use its virtual machine). I recommend doing this through [`asdf`](https://asdf-vm.com/guide/getting-started.html). This will allow you to have multiple versions of Elixir installed and easily switch between them per project or set a global version for the system. Likewise, `asdf` will also allow you to install `NodeJS` (and, similarly, manage its different versions), which is required to install the `Tailwind CSS` and `daisyUI` JavaScript packages.

    > I strongly recommend you to follow the recommendations made [here](https://github.com/emarifer/elixir-desktop-todoapp?tab=readme-ov-file#prerequisites) to create a more complete Erlang/OTP installation that will allow you to use the Erlang binding for [`wxWidgets`](https://www.erlang.org/doc/apps/wx/chapter.html), something essential to create the desktop application with the [`Desktop`](https://github.com/elixir-desktop/desktop) library, as well as prepare your system as indicated [here](https://hexdocs.pm/desktop/getting_started.html#content).

    > As of this writing, the latest version of the Phoenix framework (v1.8.1) has an [issue](https://github.com/tailwindlabs/tailwindcss-intellisense/issues/1474) with the autocompletion of `Tailwind CSS` utility classes in `VScode` (and other editors), as well as with the integration with its `daisyUI` plugin. The [workaround](https://github.com/tailwindlabs/tailwindcss-intellisense/issues/1301#issuecomment-2784572273) requires manual installation of Tailwind CSS and daisyUI via `npm`, although CSS compilation is still done by Phoenix via the `tailwind/esbuild` binaries. This is the solution I have adopted in this application.

    > The previous version of the `Desktop` library would throw errors when trying to create menu structures from `XML`. This was due to the change made in `Phoenix/Phoenix LiveView`. The current version of `Desktop` has fixed this problem, but requires `Phoenix >= 1.8` to run correctly. If you intend to create a `Desktop` application and you still have Phoenix code generators from previous versions installed on your system, you will need to upgrade by first uninstalling (`mix archive.uninstall phx_new`) and then installing again (`mix archive.install hex phx_new`), which will install the Phoenix generators binaries in `your_home_folder/.asdf/installs/elixir/1.18.4/.mix/archives/`, if you installed Elixir-Erlang/OTP using `asdf`.

  * **Usage**: Once you've completed the above requirements, you're ready to begin. Clone the repository and navigate to the project root to run the following command in the terminal:

    ```
    $ mix installer
    ```

    The above command is a `mix task` (an `alias`) that I created to simplify the installer generation. It downloads the Elixir dependencies, downloads and installs the JavaScript dependencies via `npm/NodeJS` (`Tailwind CSS`, `daisyUI`, and `SweetAlert2`. For the need to install Tailwind CSS/daisyUI, see one of the previous notes), generates the assets that Phoenix needs for production, and finally, creates the application installer appropriate for your OS/version. This step may take more or less time to execute depending on your machine.

    The installer is created in the `_build/prod` folder with the name and version determined in the `mix.exs` file (`_build/prod/Todolist_WebUI_Desktopapp-0.1.0-linux-x86_64.run`, e.g.).


    Now run it. If you don't pass a path, it will install the application in your home directory. However, I recommend passing the path where applications are usually installed on your system:

    ```
    $ ./_build/prod/Todolist_WebUI_Desktopapp-0.1.0-linux-x86_64.run $HOME/.local/bin # e.g. on Linux
    ```

    This command will unzip the folder containing the application to the given path. This creates a `self-contained` folder containing everything needed to run the application on any system without having to install any dependencies: the application binaries, the `BEAM VM` and `runtime`, all the necessary `graphics libraries` and dependencies for your OS, and the `assets` used by any Phoenix application. It also generates a launcher (`*.desktop` file in Linux) that will make the application appear in your start menu. Likewise, (on Linux) another launcher will be created in `$HOME/.config/autostart/` that will launch the application when you log in to your system (but you can remove it if you don't want this behavior).

---

### 📚 Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix
* Phoenix LiveView: https://hexdocs.pm/phoenix_live_view/welcome.html
* Ecto: https://hexdocs.pm/ecto/Ecto.html
* Ecto SQL: https://hexdocs.pm/ecto_sql/Ecto.Adapters.SQL.html
* Desktop (elixir-desktop): https://hexdocs.pm/desktop/readme.html
* Deployment (elixir-desktop): https://github.com/elixir-desktop/deployment
* Gettext: https://hexdocs.pm/gettext/Gettext.html

---

### Happy coding 😀!!
