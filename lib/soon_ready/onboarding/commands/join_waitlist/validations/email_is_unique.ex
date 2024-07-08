defmodule SoonReady.Onboarding.Commands.JoinWaitlist.Validations.EmailIsUnique do
  use Ash.Resource.Validation

  alias Ash.Error.Changes.InvalidAttribute
  alias SoonReady.Onboarding.ReadModels.WaitlistMembers

  @opt_schema [
    email_field: [
      type: :atom,
      required: true
    ],
  ]


  @impl true
  def init(opts) do
    case Spark.OptionsHelpers.validate(opts, @opt_schema) do
      {:ok, opts} ->
        {:ok, opts}

      {:error, error} ->
        {:error, Exception.message(error)}
    end
  end

  @impl true
  def validate(changeset, opts, _context) do
    case Ash.Changeset.get_argument_or_attribute(changeset, opts[:email_field]) do
      nil ->
        :ok
      email ->
        case WaitlistMembers.get_by_email(%{email: email}) do
          {:error, %Ash.Error.Query.NotFound{}} ->
            :ok
          _ ->
            {:error, InvalidAttribute.exception(
              field: opts[:email_field],
              message: "already in waitlist"
            )}
        end
    end
  end
end
