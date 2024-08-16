defmodule SoonReadyInterface.Respondent.Webpages.SurveyParticipationLive.FormViewModel.CheckboxQuestionResponse do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :id, :uuid, primary_key?: true, allow_nil?: false, public?: true
    attribute :prompt, :string, allow_nil?: false, public?: true
    attribute :options, {:array, :string}, allow_nil?: false, public?: true
    attribute :correct_answer_criteria, :atom, constraints: [one_of: [:not_applicable, :any_correct_option, :all_correct_options]], default: :not_applicable, allow_nil?: false, public?: true
    # TODO: nil is always allowed. Resolve.
    attribute :responses, {:array, :string}, allow_nil?: true, public?: true
  end

  actions do
    default_accept [:id, :prompt, :options, :correct_answer_criteria, :responses]
    defaults [:read, :update, :destroy]

    create :create do
      primary? true
      allow_nil_input [:responses]
    end
  end
end
