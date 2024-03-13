defmodule SoonReady.QuantifyingNeeds.Survey do
  use Ash.Api
  use Commanded.Commands.Router

  alias SoonReady.QuantifyingNeeds.Survey.Commands.{CreateSurvey, PublishSurvey}
  alias SoonReady.QuantifyingNeeds.Survey.DomainEvents.{SurveyCreated, SurveyPublished}

  dispatch CreateSurvey, to: __MODULE__, identity: :survey_id
  dispatch PublishSurvey, to: __MODULE__, identity: :survey_id

  defstruct [:survey_id]

  defdelegate create_survey(params), to: CreateSurvey, as: :dispatch
  defdelegate publish_survey(params), to: PublishSurvey, as: :dispatch

  def execute(_aggregate_state, %CreateSurvey{} = command) do
    SurveyCreated.new(%{
      survey_id: command.survey_id,
      brand: command.brand,
      market: command.market,
      job_steps: command.job_steps,
      screening_questions: command.screening_questions,
      demographic_questions: command.demographic_questions,
      context_questions: command.context_questions
    })
  end

  def execute(_aggregate_state, %PublishSurvey{} = command) do
    SurveyPublished.new(%{
      survey_id: command.survey_id
    })
  end

  def apply(state, _event) do
    state
  end
end
