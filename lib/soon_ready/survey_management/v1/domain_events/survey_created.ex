defmodule SoonReady.SurveyManagement.V1.DomainEvents.SurveyCreated do
  use Ash.Resource,
    domain: SoonReady.SurveyManagement,
    extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.V1.DomainConcepts.{SurveyPage, Trigger}
  alias SoonReady.SurveyManagement.V1.DomainEvents.Helpers

  attributes do
    attribute :survey_id, :uuid, allow_nil?: false, primary_key?: true, public?: true
    attribute :starting_page_id, :uuid, allow_nil?: false, public?: true
    attribute :pages_dumped_data, {:array, :map}, public?: true
    attribute :trigger, Trigger, public?: true
  end

  calculations do
    calculate :pages, {:array, SurveyPage}, fn [record], _context ->
      {:ok, pages} = Helpers.cast_stored(record.pages_dumped_data)
      {:ok, [pages]}
    end
  end

  changes do
    change load(:pages)
  end

  actions do
    default_accept [
      :survey_id,
      :starting_page_id,
      :pages_dumped_data,
      :trigger,
    ]
    defaults [:read]

    create :new

    create :regenerate do
      argument :event, :struct, constraints: [instance_of: __MODULE__], allow_nil?: false

      change fn changeset, _context ->
        event = Ash.Changeset.get_argument(changeset, :event)

        changeset
        |> Ash.Changeset.change_attribute(:survey_id, event.survey_id)
        |> Ash.Changeset.change_attribute(:starting_page_id, event.starting_page_id)
        |> Ash.Changeset.change_attribute(:pages_dumped_data, event.pages_dumped_data)
        |> Ash.Changeset.change_attribute(:trigger, event.trigger)
      end
    end
  end

  code_interface do
    define :new
    define :regenerate, args: [:event]
  end
end
