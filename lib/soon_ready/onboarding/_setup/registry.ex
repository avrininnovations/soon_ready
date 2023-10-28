defmodule SoonReady.Onboarding.Setup.Registry do
  use Ash.Registry,
    extensions: [
      Ash.Registry.ResourceValidations
    ]

  entries do
    entry SoonReady.Onboarding.ReadModels.WaitlistMembers
  end
end