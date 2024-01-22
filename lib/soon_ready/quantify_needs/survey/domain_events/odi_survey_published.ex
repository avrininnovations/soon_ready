# defmodule SoonReady.QuantifyNeeds.Survey.DomainEvents.OdiSurveyPublished do
#   use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

#   alias SoonReady.QuantifyNeeds.Survey.ValueObjects.{
#     Market,
#     JobStep,
#     ScreeningQuestion,
#     DemographicQuestion,
#     ContextQuestion
#   }

#   attributes do
#     attribute :survey_id, :uuid, allow_nil?: false, primary_key?: true
#     attribute :brand, :string, allow_nil?: false
#     attribute :market, Market, allow_nil?: false
#     attribute :job_steps, {:array, JobStep}, allow_nil?: false, constraints: [min_length: 1]
#     attribute :screening_questions, {:array, ScreeningQuestion}, allow_nil?: false, constraints: [min_length: 1]
#     attribute :demographic_questions, {:array, DemographicQuestion}, allow_nil?: false, constraints: [min_length: 1]
#     attribute :context_questions, {:array, ContextQuestion}, allow_nil?: false, constraints: [min_length: 1]
#     attribute :event_version, :integer, allow_nil?: false, default: 1
#   end

#   actions do
#     create :new
#   end

#   code_interface do
#     define_for SoonReady.QuantifyNeeds.Survey.Setup.Api
#     define :new
#   end
# end
