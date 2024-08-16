defmodule SoonReadyInterface.Respondent.Commands.SubmitSurveyResponse do
  use Ash.Resource, domain: SoonReadyInterface.Respondent

  alias SoonReady.Application
  alias SoonReady.SurveyManagement.DomainConcepts.Response

  attributes do
    uuid_primary_key :response_id
    attribute :survey_id, :uuid, allow_nil?: false
    attribute :responses, {:array, Response}, allow_nil?: false
    attribute :raw_responses_data, {:array, :map}, allow_nil?: false
  end

  actions do
    default_accept [
      :survey_id,
      :responses,
      :raw_responses_data,
    ]

    create :dispatch do
      argument :responses, {:array, :map}, allow_nil?: false

      change fn changeset, context ->
        responses = Ash.Changeset.get_argument(changeset, :responses)

        changeset
        |> Ash.Changeset.change_attribute(:responses, responses)
        |> Ash.Changeset.change_attribute(:raw_responses_data, responses)
      end

      change fn changeset, context ->
        Ash.Changeset.after_action(changeset, fn changeset, command ->
          with :ok <- Application.dispatch(command) do
            {:ok, command}
          end
        end)
      end
    end
  end

  code_interface do
    define :dispatch
  end
end
