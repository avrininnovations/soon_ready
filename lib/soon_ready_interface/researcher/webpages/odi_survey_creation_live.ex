defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive do
  use SoonReadyInterface, :live_view

  require Logger

  import SoonReadyInterface.Researcher.Common.Components, only: [page: 1]

  alias SoonReadyInterface.Researcher.Common.Layout

  alias SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.LiveComponents.{
    LandingPage,
    MarketDefinitionPage,
    DesiredOutcomesPage,
    ScreeningQuestionsPage,
    DemographicQuestionsPage,
    ContextQuestionsPage
  }

  def mount(_params, _session, socket) do
    case Map.get(socket.assigns, :current_user) do
      %{is_researcher: true} = current_user ->
        socket = assign(socket, :actor, current_user)
        {:ok, socket, layout: {Layout, :layout}}
      _ ->
        socket =
          socket
          |> redirect(to: ~p"/sign-in")
          |> put_flash(:error, "A signed in researcher is required")
        {:ok, socket}
    end
  end

  def handle_params(params, _url, socket) do
    {:noreply, assign(socket, params: params)}
  end

  def render(%{live_action: :landing_page} = assigns) do
    ~H"""
    <.live_component module={LandingPage} id="landing_page" />
    """
  end

  def render(%{live_action: :market_definition_page} = assigns) do
    ~H"""
    <.live_component module={MarketDefinitionPage} id="market_definition_page" />
    """
  end

  def render(%{live_action: :desired_outcomes_page} = assigns) do
    ~H"""
    <.live_component module={DesiredOutcomesPage} id="desired_outcomes_page" />
    """
  end

  def render(%{live_action: :screening_questions_page} = assigns) do
    ~H"""
    <.live_component module={ScreeningQuestionsPage} id="screening_questions_page" />
    """
  end

  def render(%{live_action: :demographic_questions_page} = assigns) do
    ~H"""
    <.live_component module={DemographicQuestionsPage} id="demographic_questions_page" />
    """
  end

  def render(%{live_action: :context_questions_page} = assigns) do
    ~H"""
    <.live_component module={ContextQuestionsPage} id="context_questions_page" />
    """
  end

  def handle_info({:update_params, new_params}, socket) do
    params = Map.merge(socket.assigns.params, new_params)
    {:noreply, assign(socket, :params, params)}
  end

  def handle_info({:handle_submission, LandingPage}, socket) do
    {:noreply, push_patch(socket, to: ~p"/odi-survey/create/market-definition?#{socket.assigns.params}")}
  end

  def handle_info({:handle_submission, MarketDefinitionPage}, socket) do
    {:noreply, push_patch(socket, to: ~p"/odi-survey/create/desired-outcomes?#{socket.assigns.params}")}
  end

  def handle_info({:handle_submission, DesiredOutcomesPage}, socket) do
    {:noreply, push_patch(socket, to: ~p"/odi-survey/create/screening-questions?#{socket.assigns.params}")}
  end

  def handle_info({:handle_submission, ScreeningQuestionsPage}, socket) do
    {:noreply, push_patch(socket, to: ~p"/odi-survey/create/demographic-questions?#{socket.assigns.params}")}
  end

  def handle_info({:handle_submission, DemographicQuestionsPage}, socket) do
    {:noreply, push_patch(socket, to: ~p"/odi-survey/create/context-questions?#{socket.assigns.params}")}
  end

  def handle_info({:handle_submission, ContextQuestionsPage}, socket) do
    normalized_params = normalize(socket.assigns.params)

    {:ok, _command} = SoonReady.OutcomeDrivenInnovation.create_survey(%{
      brand_name: normalized_params.brand_name,
      market: normalized_params.market,
      job_steps: normalized_params.job_steps,
      screening_questions: normalized_params.screening_questions,
      demographic_questions: normalized_params.demographic_questions,
      context_questions: normalized_params.context_questions,
    })

    socket =
      socket
      |> push_redirect(to: ~p"/")
      |> put_flash(:info, "Survey published successfully!")
    {:noreply, socket}
  end

  defp normalize(params) do
    screening_questions = Enum.map(params["screening_questions_form"]["screening_questions"], fn {_index, screening_question} ->
      %{type: "multiple_choice_question", id: Ash.UUID.generate(), prompt: screening_question["prompt"],
        options: Enum.map(screening_question["options"], fn {_index, option} ->
          %{type: "option_with_correct_flag", value: option["value"], correct?: option["is_correct_option"] == "true"}
        end)
      }
    end)

    demographic_questions = Enum.map(params["demographic_questions_form"]["demographic_questions"], fn {_index, demographic_question} ->
      %{type: "multiple_choice_question", prompt: demographic_question["prompt"],
        options: Enum.map(demographic_question["options"], fn {_index, option} -> option["value"] end)
      }
    end)

    context_questions = Enum.map(params["context_questions_form"]["context_questions"], fn
      {_index, %{"_union_type" => "Elixir.SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.Forms.ContextQuestionsForm.MultipleChoiceQuestion"} = context_question} ->
        %{type: "multiple_choice_question", prompt: context_question["prompt"],
          options: Enum.map(context_question["options"], fn {_index, option} -> option["value"] end)
        }
      {_index, %{"_union_type" => "Elixir.SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.Forms.ContextQuestionsForm.CheckboxQuestion"} = context_question} ->
        %{type: "checkbox_question", prompt: context_question["prompt"],
          options: Enum.map(context_question["options"], fn {_index, option} -> option["value"] end)
        }
      {_index, %{"_union_type" => "Elixir.SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.Forms.ContextQuestionsForm.ShortAnswerQuestionGroup"} = context_question} ->
        %{type: "short_answer_question_group", group_prompt: context_question["group_prompt"], add_button_label: context_question["add_button_label"],
        questions: Enum.map(context_question["questions"], fn {_index, question} -> %{prompt: question["prompt"]} end)
        }
    end)

    %{
      brand_name: params["landing_page_form"]["brand_name"],
      market: %{job_executor: params["market_definition_form"]["job_executor"],
                job_to_be_done: params["market_definition_form"]["job_to_be_done"]},
      job_steps: Enum.map(params["desired_outcomes_form"]["job_steps"], fn {_index, job_step} ->
        %{name: job_step["name"],
          desired_outcomes: Enum.map(job_step["desired_outcomes"], fn {_index, desired_outcome} -> desired_outcome["value"] end)
        }
      end),
      screening_questions: screening_questions,
      demographic_questions: demographic_questions,
      context_questions: context_questions,
    }
  end
end
