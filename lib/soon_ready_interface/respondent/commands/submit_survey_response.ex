defmodule SoonReadyInterface.Respondent.Commands.SubmitSurveyResponse do
  use Ash.Resource, domain: SoonReadyInterface.Respondent

  alias SoonReady.Application
  alias SoonReady.SurveyManagement.V1.DomainConcepts.Response

  attributes do
    uuid_primary_key :response_id
    attribute :survey_id, :uuid, allow_nil?: false
    attribute :responses, {:array, Response}, allow_nil?: false
  end

  actions do
    default_accept [
      :survey_id,
      :responses,
    ]

    create :dispatch do
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
