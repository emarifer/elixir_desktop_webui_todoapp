defmodule TodoDesktopapp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Desktop.identify_default_locale(TodoDesktopappWeb.Gettext)

    children = [
      TodoDesktopappWeb.Telemetry,
      TodoDesktopapp.Repo,
      {Ecto.Migrator, repos: Application.fetch_env!(:todo_desktopapp, :ecto_repos), skip: false},
      {DNSCluster, query: Application.get_env(:todo_desktopapp, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TodoDesktopapp.PubSub},
      # Start a worker by calling: TodoDesktopapp.Worker.start_link(arg)
      # {TodoDesktopapp.Worker, arg},
      # Start to serve requests, typically the last entry
      TodoDesktopappWeb.Endpoint,
      {Desktop.Window,
       [
         app: :todo_desktopapp,
         id: TodoDesktopappWindow,
         title: "Todolist WebUI Desktopapp",
         size: {635, 550},
         icon: "static/images/logo.png",
         menubar: TodoDesktopapp.MenuBar,
         url: &TodoDesktopappWeb.Endpoint.url/0
       ]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TodoDesktopapp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TodoDesktopappWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  # defp skip_migrations?() do
  #   # By default, sqlite migrations are run when using a release
  #   System.get_env("RELEASE_NAME") == nil
  # end
end
