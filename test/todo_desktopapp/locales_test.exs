defmodule TodoDesktopapp.LocalesTest do
  use TodoDesktopapp.DataCase

  alias TodoDesktopapp.Locales

  describe "locales" do
    alias TodoDesktopapp.Locales.Locale

    import TodoDesktopapp.LocalesFixtures

    @invalid_attrs %{language: nil}

    test "list_locales/0 returns all locales" do
      locale = locale_fixture()
      assert Locales.list_locales() == [locale]
    end

    test "get_locale!/1 returns the locale with given id" do
      locale = locale_fixture()
      assert Locales.get_locale!(locale.id) == locale
    end

    test "create_locale/1 with valid data creates a locale" do
      valid_attrs = %{language: "some language"}

      assert {:ok, %Locale{} = locale} = Locales.create_locale(valid_attrs)
      assert locale.language == "some language"
    end

    test "create_locale/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Locales.create_locale(@invalid_attrs)
    end

    test "update_locale/2 with valid data updates the locale" do
      locale = locale_fixture()
      update_attrs = %{language: "some updated language"}

      assert {:ok, %Locale{} = locale} = Locales.update_locale(locale, update_attrs)
      assert locale.language == "some updated language"
    end

    test "update_locale/2 with invalid data returns error changeset" do
      locale = locale_fixture()
      assert {:error, %Ecto.Changeset{}} = Locales.update_locale(locale, @invalid_attrs)
      assert locale == Locales.get_locale!(locale.id)
    end

    test "delete_locale/1 deletes the locale" do
      locale = locale_fixture()
      assert {:ok, %Locale{}} = Locales.delete_locale(locale)
      assert_raise Ecto.NoResultsError, fn -> Locales.get_locale!(locale.id) end
    end

    test "change_locale/1 returns a locale changeset" do
      locale = locale_fixture()
      assert %Ecto.Changeset{} = Locales.change_locale(locale)
    end
  end
end
