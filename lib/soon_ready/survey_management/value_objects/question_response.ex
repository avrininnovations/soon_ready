defmodule SoonReady.SurveyManagement.ValueObjects.QuestionResponse do
  # TODO: Rename to SingleValueQuestionResponse
  # TODO: Create MultiValueQuestionResponse, :responses
  # TODO: GroupQuestionResponse, :group_prompt, :question_responses
  # TODO: GroupQuestionResponse, :prompt, :responses -> {:array, Ash.Type.Union[SingleValueQuestionResponse, MultiValueQuestionResponse]}

  # TODO: :prompt vs :label
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :prompt, :string, allow_nil?: false
    attribute :response, :string, allow_nil?: false
  end
end
