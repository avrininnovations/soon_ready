defmodule SoonReady.Onboarding.Commands.JoinWaitlist do
  use Ash.Resource, data_layer: :embedded

  alias SoonReady.Onboarding.DomainConcepts.EmailAddress

  attributes do
    uuid_primary_key :id
    attribute :email, EmailAddress, allow_nil?: false
  end

  # validations do
  #   validate {EmailIsUnique, email_field: :email}
  # end

  code_interface do
    define_for SoonReady.Onboarding.Setup.Api
    define :create
  end

  # def logic() do
  #   case WaitlistMember.get_by_email(%{email: email}) do
  #     {:ok, _waitlist_member} ->
  #       {:error, :email_already_in_waitlist}
  #     {:error, :not_found} ->

  #   end
  # end
end
