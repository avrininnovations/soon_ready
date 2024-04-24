defmodule SoonReady.UserAuthentication.Events.ResearcherRegisteredV1 do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :researcher_id, :uuid, allow_nil?: false, primary_key?: true
    attribute :user_id, :uuid, allow_nil?: false
    # TODO: Encrypt PII
    attribute :first_name, :string, allow_nil?: false
    attribute :last_name, :string, allow_nil?: false
  end

  code_interface do
    define_for SoonReady.UserAuthentication.Api
    define :create
  end
end
