defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel.MultipleChoiceQuestionGroupResponse.PromptResponse do
  use Ash.Resource, data_layer: :embedded

  alias SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel.MultipleChoiceQuestionGroupResponse.{Prompt, QuestionResponse}

  attributes do
    attribute :id, :uuid, primary_key?: true, allow_nil?: false, public?: true
    attribute :prompt, :string, allow_nil?: false, public?: true
    attribute :question_responses, {:array, QuestionResponse}, allow_nil?: false, public?: true
  end

  actions do
    default_accept [:id, :prompt, :question_responses]
    defaults [:create, :read, :update, :destroy]
  end
end
