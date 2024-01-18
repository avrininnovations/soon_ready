# defmodule SoonReady.QuantifyNeeds.SurveyResponse do
#   use Ash.Resource, data_layer: :embedded

#   attributes do
#     uuid_primary_key :id
#     attribute :survey, Survey, allow_nil: false
#     attribute :participant, Participant, allow_nil: false
#     attribute :screening_responses, {:array, Response}, allow_nil: false, constraints: [min_length: 1]
#     attribute :demographic_responses, {:array, Response}, allow_nil: false, constraints: [min_length: 1]
#     attribute :context_responses, {:array, Response}, allow_nil: false, constraints: [min_length: 1]
#     attribute :comparison_responses, {:array, Response}, allow_nil: false, constraints: [min_length: 1]
#     attribute :desired_outcome_ratings, {:array, JobStep}, allow_nil: false, constraints: [min_length: 1]
#   end

#   actions do
#     create :submit
#   end

#   code_interface do
#     define_for SoonReady.QuantifyNeeds.SurveyResponse.Api
#     define :submit
#   end
# end
