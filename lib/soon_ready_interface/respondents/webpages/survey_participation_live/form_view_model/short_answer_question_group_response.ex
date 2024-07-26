defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel.ShortAnswerQuestionGroupResponse do
  use Ash.Resource, data_layer: :embedded

  alias __MODULE__.{Response}

  attributes do
    attribute :id, :uuid, primary_key?: true, allow_nil?: false, public?: true
    attribute :group_prompt, :string, allow_nil?: false, public?: true
    attribute :add_button_label, :string, allow_nil?: false, public?: true
    # TODO: nil is always allowed. Resolve.
    attribute :responses, {:array, Response}, allow_nil?: true, public?: true
  end

  actions do
    default_accept [
      :id,
      :group_prompt,
      :add_button_label,
      :responses,
    ]
    defaults [:read, :update, :destroy]

    create :create do
      primary? true
      allow_nil_input [:responses]
    end
  end
end
