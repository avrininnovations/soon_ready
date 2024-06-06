defmodule SoonReady.SurveyManagement.DomainObjects.MultipleChoiceQuestionGroup do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.DomainObjects.{MultipleChoiceQuestion, MultipleChoiceQuestionGroupPrompt}

  attributes do
    uuid_primary_key :id
    attribute :title, :ci_string, allow_nil?: false
    attribute :prompts, {:array, MultipleChoiceQuestionGroupPrompt}, allow_nil?: false
    attribute :questions, {:array, MultipleChoiceQuestion}, allow_nil?: false
  end

  actions do
    defaults [:read]

    create :create do
      primary? true

      argument :prompts, {:array, :ci_string}, allow_nil?: false

      change fn changeset, _context ->
        case Ash.Changeset.get_argument(changeset, :prompts) do
          nil ->
            changeset
          prompts ->
            prompts = Enum.map(prompts, fn prompt -> %{prompt: prompt} end)
            Ash.Changeset.change_attribute(changeset, :prompts, prompts)
        end
      end
    end
  end
end
