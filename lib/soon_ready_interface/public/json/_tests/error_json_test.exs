defmodule SoonReadyInterface.ErrorJSONTest do
  use SoonReadyInterface.ConnCase, async: true

  test "renders 404" do
    assert SoonReadyInterface.Public.Json.ErrorJson.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert SoonReadyInterface.Public.Json.ErrorJson.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
