defmodule SoonReadyInterface.Respondent.Webpages.SurveyParticipationLive.FormViewModel.ShortAnswerQuestionGroupResponse.Response do
  use Ash.Resource, data_layer: :embedded

  alias SoonReadyInterface.Respondent.Webpages.SurveyParticipationLive.FormViewModel.ShortAnswerQuestionGroupResponse.QuestionResponse

  attributes do
    uuid_primary_key :id
    # TODO: nil is always allowed. Resolve.
    attribute :question_responses, {:array, QuestionResponse}, allow_nil?: true, public?: true
  end

  actions do
    default_accept [
      :id,
      :question_responses,
    ]
    defaults [:read, :update, :destroy]

    create :create do
      primary? true
      allow_nil_input [:question_responses]
    end
  end
end
