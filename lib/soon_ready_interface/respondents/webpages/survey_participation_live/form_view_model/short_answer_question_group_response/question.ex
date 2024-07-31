defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel.ShortAnswerQuestionGroupResponse.Question do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :id, :uuid, primary_key?: true, allow_nil?: false, public?: true
    attribute :prompt, :string, allow_nil?: false, public?: true
  end

  actions do
    default_accept [:id, :prompt]
    defaults [:create, :read, :update, :destroy]
  end
end
