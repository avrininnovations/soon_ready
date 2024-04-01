defmodule SoonReadyInterface.Respondents.ReadModels.EventHandler do
  use Commanded.Event.Handler,
    application: SoonReady.Application,
    name: "#{__MODULE__}",
    consistency: Application.get_env(:soon_ready, :consistency, :eventual)

  alias SoonReadyInterface.Respondents.ReadModels.Survey
  alias SoonReady.QuantifyingNeeds.DomainEvents.{SurveyCreatedV1, SurveyPublishedV1}

  def handle(%SurveyCreatedV1{} = event, _metadata) do
    %{
      survey_id: survey_id,
      brand: brand,
      market: market,
      job_steps: job_steps,
      screening_questions: screening_questions,
      demographic_questions: demographic_questions,
      context_questions: context_questions
    } = event

    with {:ok, _active_odi_survey} <- Survey.create(%{
      id: survey_id,
      brand: brand,
      market: market,
      job_steps: job_steps,
      screening_questions: screening_questions,
      demographic_questions: demographic_questions,
      context_questions: context_questions
    }) do
      :ok
    end
  end

  def handle(%SurveyPublishedV1{survey_id: survey_id} = _event, _metadata) do
    # TODO: Refactor this not to need query?
    with {:ok, odi_survey} <- Survey.get(survey_id),
          {:ok, _odi_survey} <- Survey.update(odi_survey, %{is_active: true})
    do
      :ok
    end
  end
end
