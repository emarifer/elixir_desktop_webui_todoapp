defmodule TodoDesktopappWeb.ErrorJSONTest do
  use TodoDesktopappWeb.ConnCase, async: true

  test "renders 404" do
    assert TodoDesktopappWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert TodoDesktopappWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
