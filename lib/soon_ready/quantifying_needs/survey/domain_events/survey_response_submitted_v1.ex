defmodule SoonReady.QuantifyingNeeds.Survey.DomainEvents.SurveyResponseSubmittedV1 do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.QuantifyingNeeds.Survey.ValueObjects.{HashedParticipant, QuestionResponse, JobStepRating}

  attributes do
    attribute :response_id, :uuid, allow_nil?: false, primary_key?: true
    attribute :survey_id, :uuid
    attribute :participant, HashedParticipant
    attribute :screening_responses, {:array, QuestionResponse}
    attribute :demographic_responses, {:array, QuestionResponse}
    attribute :context_responses, {:array, QuestionResponse}
    attribute :comparison_responses, {:array, QuestionResponse}
    attribute :desired_outcome_ratings, {:array, JobStepRating}
  end

  actions do
    create :new
  end

  code_interface do
    define_for SoonReady.QuantifyingNeeds.Survey
    define :new
  end
end
