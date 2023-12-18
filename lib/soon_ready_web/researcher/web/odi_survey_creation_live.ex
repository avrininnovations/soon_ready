defmodule SoonReadyWeb.Researcher.Web.OdiSurveyCreationLive do
  use SoonReadyWeb, :live_view

  def render(%{live_action: :landing_page} = assigns) do
    ~H"""
    <h2>Welcome to the ODI Survey Creator!</h2>
    <button phx-click="start_survey">Start Your Adventure</button>
    """
  end

  def render(%{live_action: :market_definition} = assigns) do
    ~H"""
    <h2>Market Definition</h2>
    """
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def handle_event("start_survey", _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/odi-survey/create/market-definition")}
  end
end
