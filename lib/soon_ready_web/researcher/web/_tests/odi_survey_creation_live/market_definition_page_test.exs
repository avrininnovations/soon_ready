defmodule SoonReadyWeb.OdiSurveyCreationLive.MarketDefinitionPageTest do
  use SoonReadyWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "happy path" do
    test "GIVEN: Brand name has been submitted, WHEN: Researcher tries to submit market definition details, THEN: The desrired outcomes page is displayed", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/odi-survey/create")
      {:ok, view} = brand_name_has_been_submitted(view)

      resulting_html =
        view
        |> form("form", form: %{job_executor: "Person", job_to_be_done: "Do what persons do"})
        |> put_submitter("button[name=submit]")
        |> render_submit()

      assert_patch(view, ~p"/odi-survey/create/desired-outcomes")
      assert resulting_html =~ "Desired Outcomes"
    end
  end

  defp brand_name_has_been_submitted(view) do
    resulting_html =
      view
      |> form("form", form: %{brand_name: "Big Brand Co"})
      |> put_submitter("button[name=submit]")
      |> render_submit()

    assert_patch(view, ~p"/odi-survey/create/market-definition")
    assert resulting_html =~ "Market Definition"

    {:ok, view}
  end
end
