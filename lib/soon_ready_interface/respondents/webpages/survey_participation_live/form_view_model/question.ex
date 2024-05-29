defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel.Question do
  use Ash.Resource, data_layer: :embedded

  alias SoonReady.SurveyManagement.DomainObjects.{
    ShortAnswerQuestion,
    MultipleChoiceQuestion,
    ParagraphQuestion,
    MultipleChoiceQuestionGroup,
  }

  attributes do
    attribute :id, :uuid, primary_key?: true, allow_nil?: false
    attribute :type, :atom, constraints: [one_of: [ShortAnswerQuestion, MultipleChoiceQuestion, ParagraphQuestion, MultipleChoiceQuestionGroup]]
    attribute :prompt, :string, allow_nil?: false
    attribute :options, {:array, :string}, allow_nil?: false
    # TODO: nil is always allowed. Resolve.
    attribute :response, :string, allow_nil?: true
  end

  actions do
    defaults [:read, :update, :destroy]

    create :create do
      primary? true
      allow_nil_input [:response]
    end
  end

  code_interface do
    define_for SoonReadyInterface.Respondents.Setup.Api

    define :create
  end
end
