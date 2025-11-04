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

    The installer is created in the `_build/prod/` folder with the name and version determined in the `mix.exs` file (`_build/prod/Todolist_WebUI_Desktopapp-0.1.0-linux-x86_64.run`, e.g.).


    Now run it. If you don't pass a path, it will install the application in your home directory. However, I recommend passing the path where applications are usually installed on your system:

    ```
    $ ./_build/prod/Todolist_WebUI_Desktopapp-0.1.0-linux-x86_64.run $HOME/.local/bin # e.g. on Linux
    ```

    This command will unzip the folder containing the application to the given path. This creates a `self-contained` folder containing everything needed to run the application on any system without having to install any dependencies: the application binaries, the `BEAM VM` and `runtime`, all the necessary `graphics libraries` and dependencies for your OS, and the `assets` used by any Phoenix application. It also generates a launcher (`*.desktop` file in Linux) that will make the application appear in your start menu. Likewise, (on Linux) another launcher will be created in `$HOME/.config/autostart/` that will launch the application when you log in to your system (but you can remove it if you don't want this behavior).

    Also, when the application starts for the first time, the `SQLite3` database files will be created (in the appropriate path depending on your OS) and the connection to the database will be established. This is the standard behavior of a Phoenix application with an `SQLite3` database; however, this application is configured to also perform the `migrations` that create the necessary tables within the database upon startup, which is more suitable for a desktop application.
  
- #### <ins>Modifying the application (Dev mode)</ins>

  If you've installed all the requirements outlined in the previous steps and want to modify the application, to improve your development experience you can install 3 excellent extensions if you work with VScode: [`ElixirLS`](https://marketplace.visualstudio.com/items?itemName=JakeBecker.elixir-ls), [`phoenixframework`](https://marketplace.visualstudio.com/items?itemName=phoenixframework.phoenix) and [`Tailwind CSS IntelliSense`](https://marketplace.visualstudio.com/items?itemName=bradlc.vscode-tailwindcss), and follow the instructions to correctly configure your work environment. Also, keep in mind what we said in the second note of the `Prerequisites` section because in the new version of Phoenix (`>= 1.8`) in VScode and other code editors, the autocomplete function of the TailwindCSS/daisyUI utility classes does not work and you will have to make the modifications indicated in that note.

  Having made these considerations, clone the repository and from the terminal enter the project root:

  ```
  $ git clone https://github.com/emarifer/elixir_desktop_webui_todoapp.git
  $ cd elixir_desktop_webui_todoapp
  ```

  Now you can download the Elixir and JavaScript dependencies (Tailwind CSS/daisyUI), create the database, and perform migrations, all with a single command:

  ```
  $ mix setup
  ```

  And now you can start the application in development mode with:

  ```
  $ mix phx.server
  ```

  You can also do it using Elixir's interactive shell if you prefer to run something in IEx:

  ```
  $ iex -S mix
  ```

  If you want to access the user interface `dev tools`, just like you would when developing a web application, you can do so with this trick: copy the address similar to `http://localhost:4000?k=IOIQTAREYWKCO3MMP3RBSXS62RIFYVS5RRLH7HYKTM7RGBWVDMKQ` that appears in the terminal and paste it into your browser's address bar. Now you can open the `dev tools` in your browser!

  > <ins>**Hacky Trick:**</ins> If you want to access the `dev tools` when starting the application in `production/release`, you can do the following: navigate to the folder where you already have the application installed using the terminal, select the shell script `Todolist_WebUI_Desktopapp`; if you run it, the application will start without being linked to the current console process, but if you pass it the `start` argument (as when running any `Elixir Release`), then it will be linked:

    ``` 
    $ ./Todolist_WebUI_Desktopapp start # in $HOME/.local/bin/Todolist_WebUI_Desktopapp/, e.g. from Linux
    ```
  > Since the process is linked to the current console, you'll see all its `logs`. Copy the address you see in them into your browser and open its `dev tools` 😜.

  If you're using `Linux-Ubuntu` (or derivatives), it's quite possible that when you open the application window, it will be blank. This is a known issue that can be resolved by exporting the following environment variable for the current terminal session:

  ```
  $ export WEBKIT_DISABLE_COMPOSITING_MODE=1
  ```

  Every time you save changes to your code, the application window will reload.

---

### 📚 Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Elixir Guides: https://hexdocs.pm/elixir/introduction.html
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix
* Phoenix LiveView: https://hexdocs.pm/phoenix_live_view/welcome.html
* Ecto: https://hexdocs.pm/ecto/Ecto.html
* Ecto SQL: https://hexdocs.pm/ecto_sql/Ecto.Adapters.SQL.html
* Desktop (elixir-desktop): https://hexdocs.pm/desktop/readme.html
* Deployment (elixir-desktop): https://github.com/elixir-desktop/deployment
* Gettext: https://hexdocs.pm/gettext/Gettext.html
* wx the erlang binding of wxWidgets: https://www.erlang.org/doc/apps/wx/chapter.html

---

### Happy coding 😀!!
