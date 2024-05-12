defmodule SoonReady.IdentityAndAccessManagement do
  use Ash.Api

  alias SoonReady.IdentityAndAccessManagement.Commands.RegisterResearcher

  defdelegate register_researcher(params), to: RegisterResearcher, as: :dispatch
end
