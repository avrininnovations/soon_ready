defmodule SoonReadyWeb.Researcher.Web.OdiSurveyCreationLive do
  use SoonReadyWeb, :live_view

  import SoonReadyWeb.Researcher.Web.OdiSurveyCreationLive.Components.Form, only: [text_input: 1, text_field: 1, submit: 1]
  alias SoonReadyWeb.Researcher.Web.OdiSurveyCreationLive.ViewModels.{
    BrandNameForm,
    MarketDefinitionForm,
    DesiredOutcomesForm,
    ScreeningQuestionsForm,
  }
  alias SoonReady.SurveyManagement.DomainConcepts.JobStep

  def render(%{live_action: :landing_page} = assigns) do
    ~H"""
    <h2>Welcome to the ODI Survey Creator!</h2>

    <.form :let={f} for={@brand_name_form} phx-submit="submit-brand-name">
      <.text_input
        field={f[:brand_name]}
        placeholder="What's the brand name for this survey?"
      />
      <.submit>Start Your Adventure</.submit>
    </.form>
    """
  end

  def render(%{live_action: :market_definition} = assigns) do
    ~H"""
    <h2>Market Definition</h2>

    <.form :let={f} for={@market_definition_form} phx-submit="submit-market-definition">
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

    <.form :let={f} for={@desired_outcomes_form} phx-submit="submit-desired-outcomes">
      <.inputs_for :let={ff} field={f[:job_steps]}>
        <.text_field
          field={ff[:name]}
          label={"Job Step #{ff.index + 1}"}
        />

        <.inputs_for :let={fff} field={ff[:desired_outcomes]}>
          <.text_input
            field={fff[:value]}
            placeholder="Desired Outcome"
          />
        </.inputs_for>

        <button name={ff.name} phx-click="add-desired-outcome" phx-value-name={"#{ff.name}"}>Add desired outcome</button>
      </.inputs_for>

      <.submit>Proceed</.submit>
    </.form>

    <button phx-click="add-job-step">Add job step</button>
    """
  end

  def render(%{live_action: :screening_questions} = assigns) do
    ~H"""
    <h2>Screening Questions</h2>

    <.form :let={f} for={@screening_questions_form} phx-submit="submit-screening-questions">
      <.inputs_for :let={ff} field={f[:screening_questions]}>
        <.text_field
          field={ff[:prompt]}
          label="Prompt"
        />
      </.inputs_for>

      <.submit>Proceed</.submit>
    </.form>

    <button phx-click="add-screening-question">Add screening question</button>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:brand_name_form, AshPhoenix.Form.for_create(BrandNameForm, :create, api: SoonReadyWeb.Researcher.Setup.Api))
      |> assign(:market_definition_form, AshPhoenix.Form.for_create(MarketDefinitionForm, :create, api: SoonReadyWeb.Researcher.Setup.Api))
      |> assign(:desired_outcomes_form, AshPhoenix.Form.for_create(DesiredOutcomesForm, :create, api: SoonReadyWeb.Researcher.Setup.Api, forms: [auto?: true]))
      |> assign(:screening_questions_form, AshPhoenix.Form.for_create(ScreeningQuestionsForm, :create, api: SoonReadyWeb.Researcher.Setup.Api, forms: [auto?: true]))

    {:ok, socket}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def handle_event("submit-brand-name", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.brand_name_form, params: form_params) do
      {:ok, _view_model} ->
        {:noreply, push_patch(socket, to: ~p"/odi-survey/create/market-definition")}

      {:error, form_with_error} ->
        {:noreply, assign(socket, brand_name_form: form_with_error)}
    end
  end

  def handle_event("submit-market-definition", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.market_definition_form, params: form_params) do
      {:ok, _view_model} ->
        {:noreply, push_patch(socket, to: ~p"/odi-survey/create/desired-outcomes")}

      {:error, form_with_error} ->
        {:noreply, assign(socket, market_definition_form: form_with_error)}
    end
  end

  def handle_event("submit-desired-outcomes", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.desired_outcomes_form, params: form_params) do
      {:ok, _view_model} ->
        {:noreply, push_patch(socket, to: ~p"/odi-survey/create/screening-questions")}

      {:error, form_with_error} ->
        {:noreply, assign(socket, desired_outcomes_form: form_with_error)}
    end
  end

  def handle_event("add-job-step", _params, socket) do
    desired_outcomes_form = AshPhoenix.Form.add_form(socket.assigns.desired_outcomes_form, :job_steps, validate?: socket.assigns.desired_outcomes_form.errors || false)
    {:noreply, assign(socket, desired_outcomes_form: desired_outcomes_form)}
  end

  def handle_event("add-desired-outcome", %{"name" => name} = _params, socket) do
    desired_outcomes_form = AshPhoenix.Form.add_form(socket.assigns.desired_outcomes_form, "#{name}[desired_outcomes]", validate?: socket.assigns.desired_outcomes_form.errors || false)
    {:noreply, assign(socket, desired_outcomes_form: desired_outcomes_form)}
  end

  def handle_event("add-screening-question", _params, socket) do
    screening_questions_form = AshPhoenix.Form.add_form(socket.assigns.screening_questions_form, :screening_questions, validate?: socket.assigns.screening_questions_form.errors || false)
    {:noreply, assign(socket, screening_questions_form: screening_questions_form)}
  end
end
