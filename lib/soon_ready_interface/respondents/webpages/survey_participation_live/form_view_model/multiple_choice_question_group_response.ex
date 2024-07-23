defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel.MultipleChoiceQuestionGroupResponse do
  use Ash.Resource, data_layer: :embedded

  alias __MODULE__.{Prompt, Question, PromptResponse}

  attributes do
    attribute :id, :uuid, primary_key?: true, allow_nil?: false, public?: true
    attribute :title, :string, allow_nil?: false, public?: true
    attribute :prompts, {:array, Prompt}, allow_nil?: false, public?: true
    attribute :questions, {:array, Question}, allow_nil?: false, public?: true
    # TODO: nil is always allowed. Resolve.
    attribute :prompt_responses, {:array, PromptResponse}, allow_nil?: true, public?: true
  end

  actions do
    default_accept [:id, :title, :prompts, :questions, :prompt_responses]
    defaults [:read, :update, :destroy]

    create :create do
      primary? true
      allow_nil_input [:response]
    end
  end
end
