# defmodule SoonReady.OutcomeDrivenInnovation.Commands.CreateSurvey do
#   use Ash.Resource,
#     data_layer: :embedded

#   alias SoonReady.Application
#   alias SoonReady.OutcomeDrivenInnovation.DomainConcepts.{
#     Market,
#     JobStep,
#   }
#   alias SoonReady.SurveyManagement.DomainConcepts.Question

#   attributes do
#     attribute :project_id, :uuid, primary_key?: true, allow_nil?: false
#     attribute :survey_id, :uuid, allow_nil?: false, default: &Ash.UUID.generate/0
#     attribute :screening_questions, {:array, Question}
#     attribute :demographic_questions, {:array, Question}
#     attribute :context_questions, {:array, Question}

#     # TODO: Change or eliminate this
#     attribute :raw_screening_questions, {:array, :map}
#     attribute :raw_demographic_questions, {:array, :map}
#     attribute :raw_context_questions, {:array, :map}
#   end

#   actions do
#     defaults [:create, :read]

#     create :dispatch do
#       change fn changeset, context ->
#         Ash.Changeset.after_action(changeset, fn changeset, command ->
#           with :ok <- Application.dispatch(command) do
#             {:ok, command}
#           end
#         end)
#       end
#     end
#   end

#   code_interface do
#     define_for SoonReady.OutcomeDrivenInnovation
#     define :dispatch
#     define :create
#   end
# end
