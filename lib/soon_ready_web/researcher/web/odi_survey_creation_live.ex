defmodule SoonReadyWeb.Researcher.Web.OdiSurveyCreationLive do
  use SoonReadyWeb, :live_view

  import SoonReadyWeb.Researcher.Web.OdiSurveyCreationLive.Components.Form, only: [text_field: 1, submit: 1]
  alias SoonReadyWeb.Researcher.Web.OdiSurveyCreationLive.ViewModels.MarketDefinitionForm

  def render(%{live_action: :landing_page} = assigns) do
    ~H"""
    <h2>Welcome to the ODI Survey Creator!</h2>
    <button phx-click="start_survey">Start Your Adventure</button>
    """
  end

  def render(%{live_action: :market_definition} = assigns) do
    ~H"""
    <h2>Market Definition</h2>

    <.form :let={f} for={@market_definition_form} phx-submit="submit">
      <.text_field
        field={f[:brand_name]}
        label="What's the brand name for this survey?"
      />
      <.text_field
        field={f[:job_executor]}
        label="Who is the job executor?"
      />
      <.text_field
        field={f[:job_to_be_done]}
        label="What is the job they're trying to get done?"
      />
      <.submit>Proceed</.submit>
    </.form>
    """
  end

  def render(%{live_action: :desired_outcomes} = assigns) do
    ~H"""
    <h2>Desired Outcomes</h2>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:market_definition_form, AshPhoenix.Form.for_create(MarketDefinitionForm, :create, api: SoonReadyWeb.Researcher.Setup.Api))

    {:ok, socket}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def handle_event("start_survey", _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/odi-survey/create/market-definition")}
  end

  def handle_event("submit", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.market_definition_form, params: form_params) do
      {:ok, _view_model} ->
        {:noreply, push_patch(socket, to: ~p"/odi-survey/create/desired-outcomes")}

      {:error, form_with_error} ->
        {:noreply, assign(socket, market_definition_form: form_with_error)}
    end
  end
end
