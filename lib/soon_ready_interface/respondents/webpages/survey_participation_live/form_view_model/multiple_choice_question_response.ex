defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel.MultipleChoiceQuestionResponse do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :id, :uuid, primary_key?: true, allow_nil?: false, public?: true
    attribute :prompt, :string, allow_nil?: false, public?: true
    attribute :options, {:array, :string}, allow_nil?: false, public?: true
    # TODO: nil is always allowed. Resolve.
    attribute :response, :string, allow_nil?: true, public?: true
  end

  actions do
    defaults [:read, :update, :destroy]

    create :create do
      primary? true
      allow_nil_input [:response]
    end
  end
end
