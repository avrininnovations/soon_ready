defmodule SoonReadyInterface.Respondent.Webpages.SurveyParticipationLive.Forms.SurveyPageForm.MultipleChoiceQuestionGroupResponse.QuestionResponse do
  use Ash.Resource, data_layer: :embedded

  alias SoonReadyInterface.Respondent.Webpages.SurveyParticipationLive.Forms.SurveyPageForm.MultipleChoiceQuestionGroupResponse.Question

  attributes do
    attribute :id, :uuid, primary_key?: true, allow_nil?: false, public?: true
    attribute :prompt, :string, allow_nil?: false, public?: true
    attribute :options, {:array, :string}, allow_nil?: false, public?: true
    # attribute :question, Question, allow_nil?: false
    # TODO: Nilable?
    attribute :response, :string, public?: true
  end

  actions do
    default_accept [:id, :prompt, :options, :response]
    defaults [:create, :read, :update, :destroy]
  end
end
