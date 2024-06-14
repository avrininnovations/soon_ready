# defmodule SoonReady.OutcomeDrivenInnovation.DomainConcepts.Survey.ScreeningQuestion.Validations.AtLeastOneOptionIsCorrect do
#   use Ash.Resource.Validation

#   alias Ash.Error.Changes.InvalidAttribute

#   @options_field :options

#   @impl true
#   def validate(changeset, opts) do
#     options = Ash.Changeset.get_attribute(changeset, @options_field)

#     if Enum.any?(options, fn option -> option.is_correct end) do
#       :ok
#     else
#       {:error, InvalidAttribute.exception(
#           field: @options_field,
#           message: "at least on option needs to be correct"
#         )}
#     end
#   end
# end
