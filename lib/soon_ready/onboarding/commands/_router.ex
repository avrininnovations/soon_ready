defmodule SoonReady.Onboarding.Commands.Router do
  use Commanded.Commands.Router

  alias SoonReady.Onboarding.Aggregates.WaitlistMember
  alias SoonReady.Onboarding.Commands.JoinWaitlist

  identify WaitlistMember, by: :id
  dispatch [JoinWaitlist], to: WaitlistMember
end
