defmodule SoonReady.Onboarding.Commands.JoinWaitlist.Validations.EmailIsUnique do
  use Ash.Resource.Validation

  alias Ash.Error.Changes.InvalidAttribute
  alias SoonReady.Onboarding.Aggregates.WaitlistMember

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
  def validate(changeset, opts) do
    case Ash.Changeset.get_argument_or_attribute(changeset, opts[:email_field]) do
      nil ->
        :ok
      email ->
        case WaitlistMember.get_by_email(%{email: email}) do
          # {:ok, _waitlist_member} ->
          #   {:error, InvalidAttribute.exception(
          #     field: opts[:field],
          #     message: "already in waitlist"
          #   )}
          {:error, %Ash.Error.Query.NotFound{}} ->
            :ok
          _ ->
            {:error, InvalidAttribute.exception(
              field: opts[:email_field],
              message: "already in waitlist"
            )}
          # {:error, error} ->
          #   IO.inspect(error)
          #   :ok
        end
    end
  end
end
