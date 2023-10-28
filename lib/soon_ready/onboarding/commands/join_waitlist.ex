defmodule SoonReady.Onboarding.Commands.JoinWaitlist do
  use Ash.Resource, data_layer: :embedded

  alias SoonReady.Onboarding.DomainConcepts.EmailAddress
  alias __MODULE__.Validations.EmailIsUnique

  attributes do
    uuid_primary_key :id
    attribute :email, EmailAddress, allow_nil?: false
  end

  validations do
    validate {EmailIsUnique, email_field: :email}
  end

  code_interface do
    define_for SoonReady.Onboarding.Setup.Api
    define :create
  end
end
