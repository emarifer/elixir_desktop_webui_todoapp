defmodule TodoDesktopappWeb.Utils.HandleBackup do
  alias TodoDesktopapp.Locales

  @topic_menu "restore_menubar"

  def generate_backup(path) do
    app_name = Atom.to_string(Application.get_application(__MODULE__))
    mode = Application.get_env(:todo_desktopapp, :environment)
    pass = Application.get_env(:todo_desktopapp, :pass_zip)

    db_config =
      Path.join([
        System.user_home(),
        ".config",
        app_name
      ])

    source =
      if mode == :dev do
        Path.join(File.cwd!(), "#{app_name}_dev.db")
      else
        Path.join(db_config, "database.sqlite3")
      end

    with {res_mkir, 0} when is_binary(res_mkir) <-
           System.cmd("/bin/sh", ["-c", "mkdir #{path}"], stderr_to_stdout: true),
         {res_cp, 0} when is_binary(res_cp) <-
           System.cmd("/bin/sh", ["-c", "cp #{source}* #{path}"], stderr_to_stdout: true),
         {res_zip, 0} when is_binary(res_zip) <-
           System.cmd("/bin/sh", ["-c", "zip -9rj -P #{pass} #{path}.zip #{path}"],
             stderr_to_stdout: true
           ),
         {res_rm, 0} when is_binary(res_rm) <-
           System.cmd("/bin/sh", ["-c", "rm -R #{path}"], stderr_to_stdout: true) do
      {res_mkir <> " " <> res_cp <> " " <> res_zip <> " " <> res_rm, 0}
    end
  end

  def restore_backup(path) do
    app_name = Atom.to_string(Application.get_application(__MODULE__))
    mode = Application.get_env(:todo_desktopapp, :environment)
    pass = Application.get_env(:todo_desktopapp, :pass_zip)

    db_config =
      Path.join([
        System.user_home(),
        ".config",
        app_name
      ])

    source =
      if mode == :dev do
        Path.join(path, "#{app_name}_dev.db")
      else
        Path.join(path, "database.sqlite3")
      end

    if mode == :dev do
      with {res_unzip, 0} when is_binary(res_unzip) <-
             System.cmd("/bin/sh", ["-c", "unzip -P #{pass} #{path}.zip -d #{path}"],
               stderr_to_stdout: true
             ),
           {res_cp, 0} when is_binary(res_cp) <-
             System.cmd("/bin/sh", ["-c", "cp #{source}* #{File.cwd!()}"], stderr_to_stdout: true),
           {res_rm, 0} when is_binary(res_rm) <-
             System.cmd("/bin/sh", ["-c", "rm -R #{path}"], stderr_to_stdout: true) do
        {res_unzip <> " " <> res_cp <> " " <> res_rm, 0}
      end
    else
      with {res_unzip, 0} when is_binary(res_unzip) <-
             System.cmd("/bin/sh", ["-c", "unzip -P #{pass} #{path}.zip -d #{path}"],
               stderr_to_stdout: true
             ),
           {res_cp, 0} when is_binary(res_cp) <-
             System.cmd("/bin/sh", ["-c", "cp #{source}* #{db_config}"], stderr_to_stdout: true),
           {res_rm, 0} when is_binary(res_rm) <-
             System.cmd("/bin/sh", ["-c", "rm -R #{path}"], stderr_to_stdout: true) do
        {res_unzip <> " " <> res_cp <> " " <> res_rm, 0}
      end
    end
  end

  def handle_locales do
    language = Locales.get_locales!().language
    Desktop.put_default_locale(language)

    Phoenix.PubSub.broadcast(TodoDesktopapp.PubSub, @topic_menu, :changed)
  end
end
