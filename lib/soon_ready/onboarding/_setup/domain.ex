# TODO: Rename to Domain
defmodule SoonReady.Onboarding.Setup.Domain do
  use Ash.Domain

  resources do
    resource SoonReady.Onboarding.Commands.JoinWaitlist

    resource SoonReady.Onboarding.ReadModels.WaitlistMembers
    resource SoonReady.Onboarding.PersonallyIdentifiableInformation.EncryptionDetails

    resource SoonReady.Onboarding.DomainEvents.WaitlistJoined
  end
end
