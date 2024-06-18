defmodule SoonReady.OutcomeDrivenInnovation.Events.ProjectCreatedV1 do
  use Ash.Resource,
    domain: SoonReady.OutcomeDrivenInnovation,
    extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :project_id, :uuid, allow_nil?: false, primary_key?: true, public?: true
    attribute :brand_name, :string, public?: true
  end

  actions do
    default_accept [
      :project_id,
      :brand_name,
    ]
    create :new
  end

  code_interface do
    define :new
  end
end
