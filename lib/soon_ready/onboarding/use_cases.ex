# defmodule SoonReady.Onboarding.UseCases do
#   def join_waitlist(email) do
#     alias SoonReady.Onboarding.DomainWorkflow.JoinWaitlist

#     with {:ok, command} <- JoinWaitlist.create!(%{email: email}),
#           :ok <- Application.dispatch(command)
#     do
#       {:ok, Map.from_struct(command)}
#     end
#   end
# end
