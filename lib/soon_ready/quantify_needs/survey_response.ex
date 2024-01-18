defmodule SoonReady.QuantifyNeeds.SurveyResponse do
  use Ash.Resource, data_layer: :embedded

  alias SoonReady.QuantifyNeeds.SurveyResponse.ValueObjects.{Participant, Response, JobStep}
  alias SoonReady.QuantifyNeeds.SurveyResponse.Commands.SubmitSurveyResponse
  alias SoonReady.QuantifyNeeds.SurveyResponse.DomainEvents.SurveyResponseSubmitted

  attributes do
    uuid_primary_key :id
    attribute :survey_id, :uuid, allow_nil?: false
    attribute :participant, Participant, allow_nil?: false
    attribute :screening_responses, {:array, Response}, allow_nil?: false, constraints: [min_length: 1]
    attribute :demographic_responses, {:array, Response}, allow_nil?: false, constraints: [min_length: 1]
    attribute :context_responses, {:array, Response}, allow_nil?: false, constraints: [min_length: 1]
    attribute :comparison_responses, {:array, Response}, allow_nil?: false, constraints: [min_length: 1]
    attribute :desired_outcome_ratings, {:array, JobStep}, allow_nil?: false, constraints: [min_length: 1]
  end

  actions do
    create :submit do
      # TODO: Validate that the survey is published

      change fn changeset, _context ->
        Ash.Changeset.after_action(changeset, fn changeset, result ->
          result
          |> Map.from_struct()
          |> SubmitSurveyResponse.dispatch()
          |> case do
            {:ok, _command} ->
              {:ok, result}

            {:error, error} ->
              changeset = Ash.Changeset.add_error(changeset, error)
              {:error, changeset}
          end
        end)
      end
    end
  end

  code_interface do
    define_for SoonReady.QuantifyNeeds.SurveyResponse.Api
    define :submit
  end


  # Command Handling
  use Commanded.Commands.Router
  dispatch SubmitSurveyResponse, to: __MODULE__, identity: :id

  def execute(_aggregate_state, %SubmitSurveyResponse{} = command) do
    with {:ok, participant_hash} <- __MODULE__.encrypt_participant(command) do
      SurveyResponseSubmitted.new(%{
        id: command.id,
        survey_id: command.survey_id,
        participant_hash: participant_hash,
        screening_responses: command.screening_responses,
        demographic_responses: command.demographic_responses,
        context_responses: command.context_responses,
        comparison_responses: command.comparison_responses,
        desired_outcome_ratings: command.desired_outcome_ratings
      })
    end
  end

  defp encrypt_participant(%__MODULE__{id: survey_response_id, participant: participant}) do
    with :error <- SoonReady.Vault.encrypt(%{person_id: person_id, participant: participant}, :onboarding) do
      {:error, :participant_encryption_failed}
    end
  end

  def apply(state, _event) do
    state
  end
end
