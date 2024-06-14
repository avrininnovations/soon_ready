# defmodule SoonReady.Onboarding.DomainConcepts.EmailAddress do
#   use Ash.Type

#   @impl Ash.Type
#   def storage_type(_), do: :string

#   @impl Ash.Type
#   def cast_input(value, _) do
#     if Regex.match?(~r".+@.+", value) do
#       {:ok, value}
#     else
#       {:error, "invalid email"}
#     end
#   end

#   @impl Ash.Type
#   def cast_stored(value, _) do
#     Ecto.Type.load(:string, value)
#   end

#   @impl Ash.Type
#   def dump_to_native(value, _) do
#     Ecto.Type.dump(:string, value)
#   end
# end
