defmodule SoonReadyInterface.Respondent.Webpages.SurveyParticipationLive.Forms.SurveyPageForm.ShortAnswerQuestionGroupResponse.QuestionResponse do
  use Ash.Resource, data_layer: :embedded

  alias SoonReadyInterface.Respondent.Webpages.SurveyParticipationLive.Forms.SurveyPageForm.ShortAnswerQuestionGroupResponse.QuestionResponse

  attributes do
    attribute :id, :uuid, primary_key?: true, allow_nil?: false, public?: true
    attribute :prompt, :string, allow_nil?: false, public?: true
    # TODO: nil is always allowed. Resolve.
    attribute :response, :string, allow_nil?: true, public?: true
  end

  actions do
    default_accept [
      :id,
      :prompt,
      :response,
    ]
    defaults [:read, :update, :destroy]

    create :create do
      primary? true
      allow_nil_input [:response]
    end
  end
end
