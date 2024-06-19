defmodule SoonReady.OutcomeDrivenInnovation.Events.SurveyCreationSucceededV1 do
  use Ash.Resource,
    domain: SoonReady.OutcomeDrivenInnovation,
    extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :project_id, :uuid, allow_nil?: false, primary_key?: true, public?: true
    attribute :survey_id, :uuid, allow_nil?: false, public?: true
  end

  actions do
    default_accept [
      :project_id,
      :survey_id,
    ]
    create :new
  end

  code_interface do
    define :new
  end
end
