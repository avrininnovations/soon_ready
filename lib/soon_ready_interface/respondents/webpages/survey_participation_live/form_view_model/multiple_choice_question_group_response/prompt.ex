defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel.MultipleChoiceQuestionGroupResponse.Prompt do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :id, :uuid, primary_key?: true, allow_nil?: false, public?: true
    attribute :prompt, :string, allow_nil?: false, public?: true
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end
end
