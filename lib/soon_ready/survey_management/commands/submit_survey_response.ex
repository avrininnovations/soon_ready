defmodule SoonReady.SurveyManagement.Commands.SubmitSurveyResponse do
  use Ash.Resource, data_layer: :embedded

  alias SoonReady.Application
  alias SoonReady.SurveyManagement.DomainConcepts.Response

  attributes do
    uuid_primary_key :response_id
    attribute :survey_id, :uuid, allow_nil?: false
    attribute :responses, {:array, Response}, allow_nil?: false
    attribute :raw_responses_data, {:array, :map}, allow_nil?: false
  end

  actions do
    create :dispatch do
      argument :responses, {:array, :map}, allow_nil?: false

      change fn changeset, context ->
        responses = Ash.Changeset.get_argument(changeset, :responses)

        changeset =
          changeset
          |> Ash.Changeset.change_attribute(:responses, responses)
          |> Ash.Changeset.change_attribute(:raw_responses_data, responses)

        Ash.Changeset.after_action(changeset, fn changeset, command ->
          with :ok <- Application.dispatch(command) do
            {:ok, command}
          end
        end)
      end
    end
  end

  code_interface do
    define_for SoonReady.SurveyManagement
    define :dispatch
  end
end
