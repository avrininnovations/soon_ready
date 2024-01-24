defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive do
  use SoonReadyInterface, :live_view

  require Logger

  alias SoonReady.QuantifyingNeeds.Survey
  alias SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.{
    LandingPageForm,
    MarketDefinitionForm,
    DesiredOutcomesForm,
    ScreeningQuestionsForm,
    DemographicQuestionsForm,
    ContextQuestionsForm
  }

  def layout(assigns) do
    ~H"""
    <main class="dark:text-white">
      <.flash_group flash={@flash} />
      <header>
        <nav class="bg-white border-gray-200 px-4 lg:px-6 py-4 dark:bg-gray-800">
          <div class="flex flex-wrap justify-center items-center mx-auto max-w-screen-xl">
            <a href={~p"/"} class="flex items-center">
              <span class="self-center text-xl font-semibold whitespace-nowrap dark:text-white">😎 SoonReady</span>
            </a>
          </div>
        </nav>
      </header>
      <%= @inner_content %>
    </main>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket, layout: {__MODULE__, :layout}}
  end

  def render(%{live_action: :landing_page} = assigns) do
    ~H"""
    <section class="bg-white dark:bg-gray-900">
      <div class="py-8 lg:py-16 px-4 mx-auto max-w-screen-md">
          <h2 class="mb-4 text-4xl tracking-tight font-extrabold text-center text-gray-900 dark:text-white">
            Welcome to the ODI Survey Creator!
          </h2>
          <p class="mb-8 lg:mb-16 font-light text-center text-gray-500 dark:text-gray-400 sm:text-xl">
            Are you a researcher trying to create an ODI survey? This is where to get started!
          </p>
          <.live_component module={LandingPageForm} id="landing_page_form" />
      </div>
    </section>
    """
  end

  def render(%{live_action: :market_definition} = assigns) do
    ~H"""
    <section class="bg-white dark:bg-gray-900">
      <div class="py-8 lg:py-16 px-4 mx-auto max-w-screen-md">
          <h2 class="mb-4 text-4xl tracking-tight font-extrabold text-center text-gray-900 dark:text-white">
            Market Definition
          </h2>
          <%!-- <p class="mb-8 lg:mb-16 font-light text-center text-gray-500 dark:text-gray-400 sm:text-xl">
            Are you a researcher trying to create an ODI survey? This is where to get started!
          </p> --%>
          <.live_component module={MarketDefinitionForm} id="market_definition_form" />
      </div>
    </section>
    """
  end

  def render(%{live_action: :desired_outcomes} = assigns) do
    ~H"""
    <section class="bg-white dark:bg-gray-900">
      <div class="py-8 lg:py-16 px-4">
          <h2 class="mb-4 text-4xl tracking-tight font-extrabold text-center text-gray-900 dark:text-white">
            Desired Outcomes
          </h2>
          <%!-- <p class="mb-8 lg:mb-16 font-light text-center text-gray-500 dark:text-gray-400 sm:text-xl">
            Are you a researcher trying to create an ODI survey? This is where to get started!
          </p> --%>
          <.live_component module={DesiredOutcomesForm} id="desired_outcomes_form" />
      </div>
    </section>
    """
  end

  def render(%{live_action: :screening_questions} = assigns) do
    ~H"""
    <h2>Screening Questions</h2>

    <.live_component module={ScreeningQuestionsForm} id="screening_questions_form" />
    """
  end

  def render(%{live_action: :demographic_questions} = assigns) do
    ~H"""
    <h2>Demographic Questions</h2>

    <.live_component module={DemographicQuestionsForm} id="demographic_questions_form" />
    """
  end

  def render(%{live_action: :context_questions} = assigns) do
    ~H"""
    <h2>Context Questions</h2>

    <.live_component module={ContextQuestionsForm} id="context_questions_form" />
    """
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

  def handle_info({:handle_submission, DesiredOutcomesForm}, socket) do
    {:noreply, push_patch(socket, to: ~p"/odi-survey/create/screening-questions?#{socket.assigns.params}")}
  end

  def handle_info({:handle_submission, ScreeningQuestionsForm}, socket) do
    {:noreply, push_patch(socket, to: ~p"/odi-survey/create/demographic-questions?#{socket.assigns.params}")}
  end

  def handle_info({:handle_submission, DemographicQuestionsForm}, socket) do
    {:noreply, push_patch(socket, to: ~p"/odi-survey/create/context-questions?#{socket.assigns.params}")}
  end

  def handle_info({:handle_submission, ContextQuestionsForm}, socket) do
    normalized_params = normalize(socket.assigns.params)

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
          |> put_flash(:error, "Survey creation failed. Please try again or contact support.")

          Logger.error("Survey creation failed: #{inspect(error)}")
        {:noreply, socket}
    end
  end

  defp normalize(params) do
    %{
      brand: params["landing_page_form"]["brand_name"],
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
