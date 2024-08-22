defmodule SoonReadyInterface.Respondent.Webpages.SurveyParticipationLive.Forms.SurveyPageForm do
  use SoonReadyInterface, :live_component
  use Ash.Resource, domain: SoonReadyInterface.Respondent

  alias SoonReady.SurveyManagement.V1.DomainConcepts.{
    Transition,
    ShortAnswerQuestion,
    MultipleChoiceQuestion,
    CheckboxQuestion,
    OptionWithCorrectFlag,
    ParagraphQuestion,
    ShortAnswerQuestionGroup,
    MultipleChoiceQuestionGroup,
  }

  alias SoonReady.SurveyManagement.V1.DomainConcepts.Transition.{Always, ResponseEquals, AnyTrue, AllTrue}
  alias __MODULE__.Response

  attributes do
    uuid_primary_key :id
    attribute :responses, {:array, Response}, public?: true
    attribute :page_transitions, {:array, Transition}, public?: true
  end

  calculations do
    calculate :transition, Transition, fn [resource], _context ->
      transition = Enum.find(resource.page_transitions, fn transition -> transition_condition_fulfilled(resource, transition.condition) end)
      {:ok, [transition]}
    end
  end

  actions do
    default_accept [
      :responses,
      :page_transitions,
    ]
    defaults [:create, :read, :update]

    update :submit do
      change load(:transition)
    end
  end

  code_interface do
    define :create
  end

  def transition_condition_fulfilled(_resource, %{type: Always}) do
    true
  end

  def transition_condition_fulfilled(%{responses: responses} = _resource, %{type: ResponseEquals, value: %{question_id: question_id, value: value}}) do
    Enum.any?(responses, fn response -> response.value.id == question_id && to_string(response.value.response) == to_string(value) end)
  end

  def transition_condition_fulfilled(resource, %{type: AnyTrue, value: %{conditions: conditions}}) do
    Enum.any?(conditions, fn condition -> transition_condition_fulfilled(resource, condition) end)
  end

  def transition_condition_fulfilled(resource, %{type: AllTrue, value: %{conditions: conditions}}) do
    Enum.all?(conditions, fn condition -> transition_condition_fulfilled(resource, condition) end)
  end
end
