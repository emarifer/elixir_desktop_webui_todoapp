defmodule TodoDesktopappWeb.PageController do
  use TodoDesktopappWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
