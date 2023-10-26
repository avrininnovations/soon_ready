defmodule SoonReadyWeb.Public.Web.HomepageLive.ViewModel.WaitlistForm do
  use Ash.Resource, data_layer: :embedded

  alias SoonReady.Onboarding.DomainConcepts.EmailAddress

  attributes do
    attribute :email, EmailAddress, allow_nil?: false
  end

  # validation do
  #   validate {EmailIsUnique, email_field: :email}
  # end
end
