defmodule SoonReadyInterface.Researcher.Commands.Aggregate do
  use Ash.Resource, domain: SoonReadyInterface.Researcher
  use Commanded.Commands.Router

  alias SoonReadyInterface.Researcher.Commands.CreateSurvey
  alias SoonReadyInterface.Respondent.Commands.SubmitSurveyResponse

  alias SoonReady.SurveyManagement.V1.DomainConcepts.SurveyPage
  alias SoonReady.SurveyManagement.V1.DomainConcepts.{
    ShortAnswerQuestion,
    ParagraphQuestion,
    MultipleChoiceQuestion,
    CheckboxQuestion,
    MultipleChoiceQuestionGroup,
    ShortAnswerQuestionGroup,
  }
  alias SoonReady.SurveyManagement.V1.DomainConcepts.{
    ShortAnswerQuestionResponse,
    ParagraphQuestionResponse,
    MultipleChoiceQuestionResponse,
    CheckboxQuestionResponse,
    ShortAnswerQuestionGroupResponses,
    MultipleChoiceQuestionGroupResponses,
  }

  alias SoonReady.OutcomeDrivenInnovation.V1.DomainEvents.{
    ProjectCreated,
    MarketDefined,
    NeedsDefined,
  }

  alias SoonReady.SurveyManagement.V1.DomainEvents.{SurveyCreated, SurveyPublished, SurveyResponseSubmitted}

  attributes do
    attribute :survey_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :pages, {:array, SurveyPage}
  end

  actions do
    default_accept [
      :survey_id,
      :pages,
    ]
    defaults [:create]
  end

  code_interface do
    define :create
  end

  dispatch CreateSurvey, to: __MODULE__, identity: :survey_id
  dispatch SubmitSurveyResponse, to: __MODULE__, identity: :survey_id

  def execute(aggregate_state, %CreateSurvey{} = command) do
    %{
      project_id: project_id,
      survey_id: survey_id,
      brand_name: brand_name,
      market: market,
      job_steps: job_steps,
      screening_questions: screening_questions,
      demographic_questions: demographic_questions,
      context_questions: context_questions,
      survey: survey,
      trigger: trigger,
    } = command

    with {:ok, project_created_event} <- ProjectCreated.new(%{project_id: project_id, brand_name: brand_name}),
          {:ok, market_defined_event} <- MarketDefined.new(%{project_id: project_id, market: market}),
          {:ok, needs_defined_event} <- NeedsDefined.new(%{project_id: project_id, job_steps: job_steps}),
          {:ok, survey_created_event} <- SurveyCreated.new(%{survey_id: survey.survey_id, starting_page_id: survey.starting_page_id, pages: survey.pages, trigger: trigger}),
          {:ok, survey_published_event} <- SurveyPublished.new(%{survey_id: survey.survey_id, starting_page_id: survey.starting_page_id, pages: survey.pages, trigger: trigger})
    do
      [project_created_event, market_defined_event, needs_defined_event, survey_created_event, survey_published_event]
    end
  end

  def execute(%{pages: pages} = _aggregate_state, %SubmitSurveyResponse{response_id: response_id, survey_id: survey_id, responses: responses} = command) do
    with :ok <- validate_all_required_questions_are_answered(pages, responses) do
      SurveyResponseSubmitted.new(%{
        response_id: response_id,
        survey_id: survey_id,
        responses: responses,
      })
    end
  end

  def apply(state, %SurveyPublished{} = event) do
    {:ok, %SurveyPublished{survey_id: survey_id, pages: pages} = _event} = SurveyPublished.regenerate(event)
    __MODULE__.create!(%{survey_id: survey_id, pages: pages})
  end

  def apply(state, _event) do
    state
  end

  defp validate_all_required_questions_are_answered(pages, responses) do
    required_questions =
      Enum.reduce(pages, [], fn %{questions: questions} = _page, required_questions ->
        Enum.reduce(questions, required_questions, fn question, required_questions ->
          case question do
            %Ash.Union{value: %ShortAnswerQuestion{required?: true}} ->
              [question | required_questions]
            %Ash.Union{value: %ParagraphQuestion{required?: true}} ->
              [question | required_questions]
            %Ash.Union{value: %MultipleChoiceQuestion{required?: true}} ->
              [question | required_questions]
            %Ash.Union{value: %CheckboxQuestion{required?: true}} ->
              [question | required_questions]
            %Ash.Union{value: %ShortAnswerQuestionGroup{questions: questions}} ->
              if Enum.any?(questions, fn question -> question.required? end) do
                [question | required_questions]
              else
                required_questions
              end
            %Ash.Union{value: %MultipleChoiceQuestionGroup{questions: questions}} ->
              if Enum.any?(questions, fn question -> question.required? end) do
                [question | required_questions]
              else
                required_questions
              end
            _ ->
              required_questions
          end
        end)
      end)

    unanswered_questions =
      Enum.reduce(required_questions, [], fn question, unanswered_questions ->

        has_response? = Enum.find(responses, fn
          %Ash.Union{value: %ShortAnswerQuestionResponse{} = response} -> question.value.id == response.question_id
          %Ash.Union{value: %ParagraphQuestionResponse{} = response} -> question.value.id == response.question_id
          %Ash.Union{value: %MultipleChoiceQuestionResponse{} = response} -> question.value.id == response.question_id
          %Ash.Union{value: %CheckboxQuestionResponse{} = response} -> question.value.id == response.question_id
          %Ash.Union{value: %ShortAnswerQuestionGroupResponses{} = response} -> question.value.id == response.group_id
          %Ash.Union{value: %MultipleChoiceQuestionGroupResponses{} = response} -> question.value.id == response.group_id
        end)

        if has_response? do
          unanswered_questions
        else
          [question | unanswered_questions]
        end
      end)

    if unanswered_questions == [] do
      :ok
    else
      {:error, {:unanswered_questions, unanswered_questions}}
    end
  end
end
