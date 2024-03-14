defmodule SoonReady.QuantifyingNeeds.SurveyResponse.DomainEvents.SurveyResponseSubmitted do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.QuantifyingNeeds.SurveyResponse.ValueObjects.{HashedParticipant, Response, JobStepRating}

  attributes do
    attribute :response_id, :uuid, allow_nil?: false, primary_key?: true
    attribute :survey_id, :uuid
    attribute :participant, HashedParticipant
    attribute :screening_responses, {:array, Response}
    attribute :demographic_responses, {:array, Response}
    attribute :context_responses, {:array, Response}
    attribute :comparison_responses, {:array, Response}
    attribute :desired_outcome_ratings, {:array, JobStepRating}
    attribute :event_version, :integer, allow_nil?: false, default: 1
  end

  actions do
    create :new
  end

  code_interface do
    define_for SoonReady.QuantifyingNeeds.SurveyResponse
    define :new
  end
end
