defmodule TodoDesktopappWeb.Router do
  use TodoDesktopappWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TodoDesktopappWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # scope "/", TodoDesktopappWeb do
  #   pipe_through :browser

  #   get "/", PageController, :home
  # end

  scope "/", TodoDesktopappWeb do
    pipe_through :browser

    live "/", HomeLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", TodoDesktopappWeb do
  #   pipe_through :api
  # end
end
