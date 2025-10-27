defmodule TodoDesktopapp.MixProject do
  use Mix.Project

  @name "Elixir Desktop WebUI Todoapp"
  @description "Simple and Cross-Platform DesktopApp Demo built on Phoenix with native menus, notifications, and full English/Spanish translation"

  def project do
    [
      app: :todo_desktopapp,
      version: "0.1.0",
      name: @name,
      description: @description,
      homepage_url: "https://github.com/emarifer/elixir_desktop_webui_todoapp",
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      compilers: [:phoenix_live_view] ++ Mix.compilers(),
      listeners: [Phoenix.CodeReloader],
      package: package(),
      releases: [
        default: [
          applications: [runtime_tools: :permanent, ssl: :permanent],
          steps: [:assemble, &Desktop.Deployment.generate_installer/1]
        ]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {TodoDesktopapp.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  def cli do
    [
      preferred_envs: [precommit: :test]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.8.1"},
      {:phoenix_ecto, "~> 4.5"},
      {:ecto_sql, "~> 3.13"},
      {:ecto_sqlite3, ">= 0.0.0"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 1.1.0"},
      {:lazy_html, ">= 0.1.0", only: :test},
      {:esbuild, "~> 0.10", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.3", runtime: Mix.env() == :dev},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.2.0",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.26"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.2.0"},
      {:bandit, "~> 1.5"},
      {:timex, "~> 3.7"},
      {:desktop, github: "elixir-desktop/desktop"},
      {:desktop_deployment, github: "elixir-desktop/deployment", runtimes: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": [
        "tailwind.install --if-missing",
        "esbuild.install --if-missing",
        "cmd --cd assets npm install"
      ],
      "assets.build": ["compile", "tailwind todo_desktopapp", "esbuild todo_desktopapp"],
      "assets.deploy": [
        "tailwind todo_desktopapp --minify",
        "esbuild todo_desktopapp --minify",
        "phx.digest"
      ],
      installer: ["deps.get", "assets.setup", "assets.deploy", "desktop.installer"],
      precommit: ["compile --warning-as-errors", "deps.unlock --unused", "format", "test"]
    ]
  end

  defp package() do
    [
      # maintainers: ["emarifer"],
      # licenses: ["MIT"],
      name: "Todolist_WebUI_Desktopapp",
      name_long: "Todolist WebUI Desktopapp",
      description: "Cross-Platform Desktop App Demo built on Phoenix",
      description_long: "Cross-Platform Desktop App Demo built on Phoenix",
      icon: "priv/static/images/logo.png",
      # https://developer.gnome.org/menu-spec/#additional-category-registry
      category_gnome: "GNOME;GTK;Office;",
      category_macos: "public.app-category.productivity",
      identifier: "io.todo_desktopapp.app"
    ]
  end
end
