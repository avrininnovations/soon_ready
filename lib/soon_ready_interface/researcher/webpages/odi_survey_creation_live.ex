defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive do
  use SoonReadyInterface, :live_view

  require Logger
  import SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.Components.Form, only: [
    text_input: 1,
    text_field: 1,
    submit: 1,
    checkbox: 1,
  ]
  alias SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.ViewModels.{
    # BrandNameForm,
    # MarketDefinitionForm,
    DesiredOutcomesForm,
    ScreeningQuestionsForm,
    DemographicQuestionsForm,
    ContextQuestionsForm
  }
  alias SoonReady.QuantifyingNeeds.Survey

  alias SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.{
    LandingPageForm,
    MarketDefinitionForm,
  }

  def render(%{live_action: :landing_page} = assigns) do
    ~H"""
    <h2>Welcome to the ODI Survey Creator!</h2>

    <.live_component module={LandingPageForm} id="landing_page_form" />
    """
  end

  def render(%{live_action: :market_definition} = assigns) do
    ~H"""
    <h2>Market Definition</h2>

    <.live_component module={MarketDefinitionForm} id="market_definition_form" />

    <%!-- <.form :let={f} for={@market_definition_form} phx-submit="submit-market-definition">
      <.text_field
        field={f[:job_executor]}
        label="Who is the job executor?"
      />
      <.text_field
        field={f[:job_to_be_done]}
        label="What is the job they're trying to get done?"
      />
      <.submit>Proceed</.submit>
    </.form> --%>
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

        <.inputs_for :let={fff} field={ff[:options]}>
          <.checkbox field={fff[:is_correct_option]} />
          <.text_input
            field={fff[:value]}
            placeholder="Option"
          />
        </.inputs_for>

        <button name={ff.name} phx-click="add-screening-question-option" phx-value-name={"#{ff.name}"}>Add option</button>
      </.inputs_for>

      <.submit>Proceed</.submit>
    </.form>

    <button phx-click="add-screening-question">Add screening question</button>
    """
  end

  def render(%{live_action: :demographic_questions} = assigns) do
    ~H"""
    <h2>Demographic Questions</h2>

    <.form :let={f} for={@demographic_questions_form} phx-submit="submit-demographic-questions">
      <.inputs_for :let={ff} field={f[:demographic_questions]}>
        <.text_field
          field={ff[:prompt]}
          label="Prompt"
        />

        <.inputs_for :let={fff} field={ff[:options]}>
          <.text_input
            field={fff[:value]}
            placeholder="Option"
          />
        </.inputs_for>

        <button name={ff.name} phx-click="add-demographic-question-option" phx-value-name={"#{ff.name}"}>Add option</button>
      </.inputs_for>

      <.submit>Proceed</.submit>
    </.form>

    <button phx-click="add-demographic-question">Add demographic question</button>
    """
  end

  def render(%{live_action: :context_questions} = assigns) do
    ~H"""
    <h2>Context Questions</h2>

    <.form :let={f} for={@context_questions_form} phx-submit="submit-context-questions">
      <.inputs_for :let={ff} field={f[:context_questions]}>
        <.text_field
          field={ff[:prompt]}
          label="Prompt"
        />

        <.inputs_for :let={fff} field={ff[:options]}>
          <.text_input
            field={fff[:value]}
            placeholder="Option"
          />
        </.inputs_for>

        <button name={ff.name} phx-click="add-context-question-option" phx-value-name={"#{ff.name}"}>Add option</button>
      </.inputs_for>

      <.submit>Proceed</.submit>
    </.form>

    <button phx-click="add-context-question">Add context question</button>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      # |> assign(:brand_name_form, AshPhoenix.Form.for_create(BrandNameForm, :create, api: SoonReadyInterface.Researcher.Api))
      |> assign(:market_definition_form, AshPhoenix.Form.for_create(MarketDefinitionForm, :create, api: SoonReadyInterface.Researcher.Api))
      |> assign(:desired_outcomes_form, AshPhoenix.Form.for_create(DesiredOutcomesForm, :create, api: SoonReadyInterface.Researcher.Api, forms: [auto?: true]))
      |> assign(:screening_questions_form, AshPhoenix.Form.for_create(ScreeningQuestionsForm, :create, api: SoonReadyInterface.Researcher.Api, forms: [auto?: true]))
      |> assign(:demographic_questions_form, AshPhoenix.Form.for_create(DemographicQuestionsForm, :create, api: SoonReadyInterface.Researcher.Api, forms: [auto?: true]))
      |> assign(:context_questions_form, AshPhoenix.Form.for_create(ContextQuestionsForm, :create, api: SoonReadyInterface.Researcher.Api, forms: [auto?: true]))

    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, assign(socket, params: params)}
  end

  def handle_info({:update_params, new_params}, socket) do
    params = Map.merge(socket.assigns.params, new_params)
    {:noreply, assign(socket, :params, params)}
  end

  def handle_info({:handle_submission, LandingPageForm}, socket) do
    {:noreply, push_patch(socket, to: ~p"/odi-survey/create/market-definition?#{socket.assigns.params}")}
  end

  def handle_info({:handle_submission, MarketDefinitionForm}, socket) do
    {:noreply, push_patch(socket, to: ~p"/odi-survey/create/desired-outcomes?#{socket.assigns.params}")}
  end

  def handle_event("submit-brand-name", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.brand_name_form, params: form_params) do
      {:ok, _view_model} ->
        params = Map.put(socket.assigns.params, "brand_name_form", form_params)
        {:noreply, push_patch(socket, to: ~p"/odi-survey/create/market-definition?#{params}")}

      {:error, form_with_error} ->
        {:noreply, assign(socket, brand_name_form: form_with_error)}
    end
  end

  def handle_event("submit-market-definition", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.market_definition_form, params: form_params) do
      {:ok, _view_model} ->
        params = Map.put(socket.assigns.params, "market_definition_form", form_params)
        {:noreply, push_patch(socket, to: ~p"/odi-survey/create/desired-outcomes?#{params}")}

      {:error, form_with_error} ->
        {:noreply, assign(socket, market_definition_form: form_with_error)}
    end
  end

  def handle_event("submit-desired-outcomes", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.desired_outcomes_form, params: form_params) do
      {:ok, _view_model} ->
        params = Map.put(socket.assigns.params, "desired_outcomes_form", form_params)
        {:noreply, push_patch(socket, to: ~p"/odi-survey/create/screening-questions?#{params}")}

      {:error, form_with_error} ->
        {:noreply, assign(socket, desired_outcomes_form: form_with_error)}
    end
  end

  def handle_event("submit-screening-questions", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.screening_questions_form, params: form_params) do
      {:ok, _view_model} ->
        params = Map.put(socket.assigns.params, "screening_questions_form", form_params)
        {:noreply, push_patch(socket, to: ~p"/odi-survey/create/demographic-questions?#{params}")}

      {:error, form_with_error} ->
        {:noreply, assign(socket, screening_questions_form: form_with_error)}
    end
  end

  def handle_event("submit-demographic-questions", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.demographic_questions_form, params: form_params) do
      {:ok, _view_model} ->
        params = Map.put(socket.assigns.params, "demographic_questions_form", form_params)
        {:noreply, push_patch(socket, to: ~p"/odi-survey/create/context-questions?#{params}")}

      {:error, form_with_error} ->
        {:noreply, assign(socket, demographic_questions_form: form_with_error)}
    end
  end

  def handle_event("submit-context-questions", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.context_questions_form, params: form_params) do
      {:ok, _view_model} ->
        params = Map.put(socket.assigns.params, "context_questions_form", form_params)
        normalized_params = normalize(params)

        case Survey.create(normalized_params) do
          {:ok, _aggregate} ->
            socket =
              socket
              |> push_redirect(to: ~p"/")
              |> put_flash(:info, "Survey created successfully!")
            {:noreply, socket}
          {:error, error} ->
            socket =
              socket
              |> push_patch(to: ~p"/odi-survey/create/context-questions?#{params}")
              |> put_flash(:error, "Survey creation failed. Please try again or contact support.")

              Logger.error("Survey creation failed: #{inspect(error)}")
            {:noreply, socket}
        end

      {:error, form_with_error} ->
        {:noreply, assign(socket, context_questions_form: form_with_error)}
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

  def handle_event("add-screening-question-option", %{"name" => name} = _params, socket) do
    screening_questions_form = AshPhoenix.Form.add_form(socket.assigns.screening_questions_form, "#{name}[options]", validate?: socket.assigns.screening_questions_form.errors || false)
    {:noreply, assign(socket, screening_questions_form: screening_questions_form)}
  end

  def handle_event("add-demographic-question", _params, socket) do
    demographic_questions_form = AshPhoenix.Form.add_form(socket.assigns.demographic_questions_form, :demographic_questions, validate?: socket.assigns.demographic_questions_form.errors || false)
    {:noreply, assign(socket, demographic_questions_form: demographic_questions_form)}
  end

  def handle_event("add-demographic-question-option", %{"name" => name} = _params, socket) do
    demographic_questions_form = AshPhoenix.Form.add_form(socket.assigns.demographic_questions_form, "#{name}[options]", validate?: socket.assigns.demographic_questions_form.errors || false)
    {:noreply, assign(socket, demographic_questions_form: demographic_questions_form)}
  end

  def handle_event("add-context-question", _params, socket) do
    context_questions_form = AshPhoenix.Form.add_form(socket.assigns.context_questions_form, :context_questions, validate?: socket.assigns.context_questions_form.errors || false)
    {:noreply, assign(socket, context_questions_form: context_questions_form)}
  end

  def handle_event("add-context-question-option", %{"name" => name} = _params, socket) do
    context_questions_form = AshPhoenix.Form.add_form(socket.assigns.context_questions_form, "#{name}[options]", validate?: socket.assigns.context_questions_form.errors || false)
    {:noreply, assign(socket, context_questions_form: context_questions_form)}
  end

  defp normalize(params) do
    %{
      brand: params["brand_name_form"]["brand_name"],
      market: %{job_executor: params["market_definition_form"]["job_executor"],
                job_to_be_done: params["market_definition_form"]["job_to_be_done"]},
      job_steps: Enum.map(params["desired_outcomes_form"]["job_steps"], fn {_index, job_step} ->
        %{name: job_step["name"],
          desired_outcomes: Enum.map(job_step["desired_outcomes"], fn {_index, desired_outcome} -> desired_outcome["value"] end)
        }
      end),
      screening_questions: Enum.map(params["screening_questions_form"]["screening_questions"], fn {_index, screening_question} ->
        %{prompt: screening_question["prompt"],
          options: Enum.map(screening_question["options"], fn {_index, option} ->
            %{value: option["value"],
              is_correct: option["is_correct_option"]}
          end)
        }
      end),
      demographic_questions: Enum.map(params["demographic_questions_form"]["demographic_questions"], fn {_index, demographic_question} ->
        %{prompt: demographic_question["prompt"],
          options: Enum.map(demographic_question["options"], fn {_index, option} -> option["value"] end)
        }
      end),
      context_questions: Enum.map(params["context_questions_form"]["context_questions"], fn {_index, context_question} ->
        %{prompt: context_question["prompt"],
          options: Enum.map(context_question["options"], fn {_index, option} -> option["value"] end)
        }
      end)
    }
  end
end
