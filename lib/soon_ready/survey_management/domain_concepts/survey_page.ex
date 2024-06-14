# defmodule SoonReady.SurveyManagement.DomainConcepts.SurveyPage do
#   # TODO: Rename to Page
#   use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]
#   alias SoonReady.SurveyManagement.DomainConcepts.{Question, Transition}

#   attributes do
#     # TODO: Add restrictions that set and govern what question types are allowed on a page
#     attribute :id, :uuid, primary_key?: true, allow_nil?: false
#     attribute :title, :ci_string, allow_nil?: false
#     attribute :description, :ci_string
#     attribute :questions, {:array, Question}
#     attribute :transitions, {:array, Transition}
#   end

#   actions do
#     defaults [:create, :read]
#   end

#   code_interface do
#     define_for SoonReady.SurveyManagement
#     define :create
#   end
# end
