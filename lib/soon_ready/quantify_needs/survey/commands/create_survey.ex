defmodule SoonReady.QuantifyNeeds.Survey.Commands.CreateSurvey do
  use Ash.Resource, data_layer: :embedded

  alias SoonReady.Application
  alias SoonReady.QuantifyNeeds.Survey.ValueObjects.{
    Market,
    JobStep,
    ScreeningQuestion,
    DemographicQuestion,
    ContextQuestion
  }

  attributes do
    attribute :id, :uuid, primary_key?: true, allow_nil?: false
    attribute :brand, :string
    attribute :market, Market
    attribute :job_steps, {:array, JobStep}
    attribute :screening_questions, {:array, ScreeningQuestion}
    attribute :demographic_questions, {:array, DemographicQuestion}
    attribute :context_questions, {:array, ContextQuestion}
  end

  actions do
    create :dispatch do
      change fn changeset, context ->
        Ash.Changeset.after_action(changeset, fn changeset, command ->
          with :ok <- Application.dispatch(command) do
            {:ok, command}
          end
        end)
      end
    end
  end

  code_interface do
    define_for SoonReady.QuantifyNeeds.Survey.Api
    define :dispatch
  end
end
