defmodule SoonReady.SurveyManagement.V1.DomainEvents.SurveyPublished do
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

    update :regenerate
  end

  code_interface do
    define :new
    define :regenerate
  end
end
