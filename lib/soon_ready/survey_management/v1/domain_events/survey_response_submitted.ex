defmodule SoonReady.SurveyManagement.V1.DomainEvents.SurveyResponseSubmitted do
  use Ash.Resource,
    domain: SoonReady.SurveyManagement,
    extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  require Logger
  alias SoonReady.SurveyManagement.V1.DomainConcepts.Response
  alias SoonReady.SurveyManagement.V1.DomainEvents.Helpers

  attributes do
    attribute :response_id, :uuid, allow_nil?: false, primary_key?: true, public?: true
    attribute :survey_id, :uuid, allow_nil?: false, public?: true
    attribute :responses_dumped_data, {:array, :map}, public?: true
  end

  calculations do
    calculate :responses, {:array, Response}, fn [record], _context ->
      %{arguments: [%{type: {:array, Response}} = responses_argument]} = Ash.Resource.Info.action(record, :new)
      {:ok, responses} = Helpers.cast_stored(responses_argument.type, record.responses_dumped_data, responses_argument.constraints)

      {:ok, [responses]}
    end
  end

  changes do
    change load(:responses)
  end


  actions do
    default_accept [
      :response_id,
      :survey_id,
      :responses_dumped_data,
    ]
    defaults [:create, :read]

    create :new do
      argument :responses, {:array, Response}, allow_nil?: false

      change fn changeset, _context ->
        {:ok, resource} = Ash.Changeset.apply_attributes(changeset, force?: true)
        %{arguments: [%{type: {:array, Response}} = responses_argument]} = Ash.Resource.Info.action(resource, :new)

        responses = Ash.Changeset.get_argument(changeset, :responses)
        {:ok, responses_dumped_data} = Ash.Type.dump_to_embedded(responses_argument.type, responses, responses_argument.constraints)

        Ash.Changeset.change_attribute(changeset, :responses_dumped_data, responses_dumped_data)
      end
    end

    create :regenerate do
      argument :event, :struct, constraints: [instance_of: __MODULE__], allow_nil?: false

      change fn changeset, _context ->
        event = Ash.Changeset.get_argument(changeset, :event)

        changeset
        |> Ash.Changeset.change_attribute(:response_id, event.response_id)
        |> Ash.Changeset.change_attribute(:survey_id, event.survey_id)
        |> Ash.Changeset.change_attribute(:responses_dumped_data, event.responses_dumped_data)
      end
    end
  end

  code_interface do
    define :new
    define :regenerate, args: [:event]
  end
end
