defmodule SoonReady.OutcomeDrivenInnovation.ResearchProject do
  use Ash.Resource
  use Commanded.Commands.Router
  use Commanded.Event.Handler,
    application: SoonReady.Application,
    name: "#{__MODULE__}",
    consistency: Application.get_env(:soon_ready, :consistency, :eventual)

  alias SoonReady.OutcomeDrivenInnovation.Commands.{CreateSurvey}
  alias SoonReady.OutcomeDrivenInnovation.Events.{SurveyCreationRequestedV1}


  attributes do
    attribute :project_id, :uuid, primary_key?: true, allow_nil?: false
  end

  dispatch CreateSurvey, to: __MODULE__, identity: :project_id

  def execute(_aggregate_state, %CreateSurvey{} = command) do
    SurveyCreationRequestedV1.new(%{
      project_id: command.project_id,
      brand: command.brand,
      market: command.market,
      job_steps: command.job_steps,
      screening_questions: command.screening_questions,
      demographic_questions: command.demographic_questions,
      context_questions: command.context_questions
    })
  end

  def handle(%SurveyCreationRequestedV1{} = event, _metadata) do
    %{
      project_id: project_id,
      brand: brand,
      market: market,
      job_steps: job_steps,
      screening_questions: screening_questions,
      demographic_questions: demographic_questions,
      context_questions: context_questions
    } = event


    landing_page_id = Ecto.UUID.generate()
    screening_page_id = Ecto.UUID.generate()
    contact_details_page_id = Ecto.UUID.generate()
    demographics_page_id = Ecto.UUID.generate()
    context_page_id = Ecto.UUID.generate()
    comparison_page_id = Ecto.UUID.generate()
    desired_outcome_rating_page_id = Ecto.UUID.generate()
    # TODO:
    # thank_you_page_id = Ecto.UUID.generate()

    survey = %{
      trigger: %{event_name: SurveyCreationRequestedV1, event_id: project_id},
      pages: [
        %{
          id: landing_page_id,
          actions: %{correct_response_action: %{type: "change_page", destination_page_id: screening_page_id}, incorrect_response_action: %{type: "change_page", destination_page_id: screening_page_id}},
          questions: [
            # %{type: "short_answer_question", prompt: "Your nickname"},
          ]
        },
        # %{
        #   id: screening_page_id,
        #   actions: %{correct_response_action: %{type: "change_page", destination_page_id: contact_details_page_id}, incorrect_response_action: :submit_form},
        #   questions: Enum.map(screening_questions, fn %{prompt: prompt, options: options} = _screening_question ->
        #     options = Enum.map(options, fn %{value: value, is_correct: is_correct} = _option -> %{value: value, correct?: is_correct} end)
        #     %{prompt: prompt, options: options}
        #   end)
        # },
        # %{
        #   id: page_3_id,
        #   actions: %{correct_response_action: :submit_form, incorrect_response_action: :submit_form},
        #   questions: [
        #     %{type: "short_answer_question", prompt: "The short answer prompt"},
        #   ]
        # },
      ]
    }

    {:ok, %{survey_id: survey_id} = survey} = SoonReady.SurveyManagement.create_survey(survey)
    # {:ok, %{survey_id: ^survey_id}} = SoonReady.SurveyManagement.publish_survey(%{survey_id: survey_id})

    :ok

    # TODO: Dispatch survey published


    # TODO: Return :ok
    # TODO: Handle failure with its own event
    # SoonReady.SurveyManagement.create_survey()

  end

  def apply(state, _event) do
    state
  end
end
