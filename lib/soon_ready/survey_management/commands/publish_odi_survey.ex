defmodule SoonReady.SurveyManagement.Commands.PublishOdiSurvey do
  use Ash.Resource, data_layer: :embedded

  alias SoonReady.SurveyManagement.ValueObjects.{
    Market,
    JobStep,
    ScreeningQuestion,
    DemographicQuestion,
    ContextQuestion
  }

  attributes do
    uuid_primary_key :survey_id
    attribute :brand, :string, allow_nil?: false
    attribute :market, Market, allow_nil?: false
    attribute :job_steps, {:array, JobStep}, allow_nil?: false, constraints: [min_length: 1]
    attribute :screening_questions, {:array, ScreeningQuestion}, allow_nil?: false, constraints: [min_length: 1]
    attribute :demographic_questions, {:array, DemographicQuestion}, allow_nil?: false, constraints: [min_length: 1]
    attribute :context_questions, {:array, ContextQuestion}, allow_nil?: false, constraints: [min_length: 1]
  end

  actions do
    create :new
  end

  code_interface do
    define_for SoonReady.SurveyManagement.Setup.Api
    define :new
  end

  def execute(command, _state) do
    SoonReady.SurveyManagement.DomainEvents.OdiSurveyPublished.new(%{
      survey_id: command.survey_id,
      brand: command.brand,
      market: command.market,
      job_steps: command.job_steps,
      screening_questions: command.screening_questions,
      demographic_questions: command.demographic_questions,
      context_questions: command.context_questions
    })
  end
end
