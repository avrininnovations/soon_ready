# defmodule SoonReady.OutcomeDrivenInnovation do
#   use Ash.Api

#   alias SoonReady.OutcomeDrivenInnovation.Commands.{
#     CreateProject,
#     DefineMarket,
#     DefineNeeds,
#     CreateSurvey,
#   }

#   resources do

#   end

#   authorization do
#     authorize :by_default
#   end

#   defdelegate create_project(params), to: CreateProject, as: :dispatch
#   defdelegate define_market(params), to: DefineMarket, as: :dispatch
#   defdelegate define_needs(params), to: DefineNeeds, as: :dispatch
#   defdelegate create_survey(params), to: CreateSurvey, as: :dispatch
#   # def create_survey(params, actor \\ nil), do: CreateSurvey.dispatch(params, [actor: actor])
# end
