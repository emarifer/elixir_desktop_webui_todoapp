defmodule TodoDesktopapp.Repo do
  use Ecto.Repo,
    otp_app: :todo_desktopapp,
    adapter: Ecto.Adapters.SQLite3
end
