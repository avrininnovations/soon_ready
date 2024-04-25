defmodule SoonReady.QuantifyingNeeds.Checks.ActorIsResearcher do
  use Ash.Policy.SimpleCheck

  def describe(_) do
    "actor is a researcher"
  end

  def match?(%SoonReady.UserAuthentication.Entities.User{is_researcher: true}, _context, _opts) do
    true
  end

  def match?(_actor, _context, _opts) do
    false
  end
end
