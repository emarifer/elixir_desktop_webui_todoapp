defmodule TodoDesktopappWeb.Utils.HandleBackup do
  alias TodoDesktopapp.Locales

  @topic_menu "restore_menubar"

  def generate_backup(path) do
    app_name = Atom.to_string(Application.get_application(__MODULE__))
    mode = Application.get_env(:todo_desktopapp, :environment)

    db_config =
      Path.join([
        System.user_home(),
        ".config",
        app_name
      ])

    file_name = ~c"#{Path.join(path, "#{app_name}.zip")}"

    if mode == :dev do
      :zip.zip(file_name, files_list(), cwd: ~c"#{File.cwd!()}")
    else
      :zip.zip(file_name, files_list(), cwd: ~c"#{db_config}")
    end
  end

  def restore_backup(path) do
    app_name = Atom.to_string(Application.get_application(__MODULE__))
    mode = Application.get_env(:todo_desktopapp, :environment)

    db_config =
      Path.join([
        System.user_home(),
        ".config",
        app_name
      ])

    if mode == :dev do
      :zip.unzip(~c"#{path}", cwd: ~c"#{File.cwd!()}")
    else
      :zip.unzip(~c"#{path}", cwd: ~c"#{db_config}")
    end
  end

  def handle_locales do
    language = Locales.get_locales!().language
    Desktop.put_default_locale(language)

    Phoenix.PubSub.broadcast(TodoDesktopapp.PubSub, @topic_menu, :changed)
  end

  defp files_list do
    app_name = Atom.to_string(Application.get_application(__MODULE__))
    mode = Application.get_env(:todo_desktopapp, :environment)

    source =
      if mode == :dev do
        "#{app_name}_dev.db"
      else
        "database.sqlite3"
      end

    [source, "#{source}-shm", "#{source}-wal"]
    |> Enum.map(&String.to_charlist/1)
  end
end

# files = ["todo_desktopapp_dev.db", "todo_desktopapp_dev.db-shm", "todo_desktopapp_dev.db-wal"
# files = files |> Enum.map(&String.to_charlist/1)
# {ok, filename} = :zip.create("file.zip", files, cwd: "/path/to/dir")
# :zip.unzip(~c"file.zip", [{:cwd, ~c"#{File.cwd!()}/file/"}])

# with {res_mkir, 0} when is_binary(res_mkir) <-
#        System.cmd("/bin/sh", ["-c", "mkdir #{path}"], stderr_to_stdout: true),
#      {res_cp, 0} when is_binary(res_cp) <-
#        System.cmd("/bin/sh", ["-c", "cp #{source}* #{path}"], stderr_to_stdout: true),
#      {res_zip, 0} when is_binary(res_zip) <-
#        System.cmd("/bin/sh", ["-c", "zip -9rj -P #{pass} #{path}.zip #{path}"],
#          stderr_to_stdout: true
#        ),
#      {res_rm, 0} when is_binary(res_rm) <-
#        System.cmd("/bin/sh", ["-c", "rm -R #{path}"], stderr_to_stdout: true) do
#   {res_mkir <> " " <> res_cp <> " " <> res_zip <> " " <> res_rm, 0}
# end

# if mode == :dev do
#   with {res_unzip, 0} when is_binary(res_unzip) <-
#          System.cmd("/bin/sh", ["-c", "unzip -P #{pass} #{path} -d #{path_no_ext}"],
#            stderr_to_stdout: true
#          ),
#        {res_cp, 0} when is_binary(res_cp) <-
#          System.cmd("/bin/sh", ["-c", "cp #{source}* #{File.cwd!()}"], stderr_to_stdout: true),
#        {res_rm, 0} when is_binary(res_rm) <-
#          System.cmd("/bin/sh", ["-c", "rm -R #{path_no_ext}"], stderr_to_stdout: true) do
#     {res_unzip <> " " <> res_cp <> " " <> res_rm, 0}
#   end
# else
#   with {res_unzip, 0} when is_binary(res_unzip) <-
#          System.cmd("/bin/sh", ["-c", "unzip -P #{pass} #{path} -d #{path_no_ext}"],
#            stderr_to_stdout: true
#          ),
#        {res_cp, 0} when is_binary(res_cp) <-
#          System.cmd("/bin/sh", ["-c", "cp #{source}* #{db_config}"], stderr_to_stdout: true),
#        {res_rm, 0} when is_binary(res_rm) <-
#          System.cmd("/bin/sh", ["-c", "rm -R #{path_no_ext}"], stderr_to_stdout: true) do
#     {res_unzip <> " " <> res_cp <> " " <> res_rm, 0}
#   end
# end
