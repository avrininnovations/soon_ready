defmodule SoonReady.OutcomeDrivenInnovation.Commands.CreateSurvey do
  use Ash.Resource,
    authorizers: [Ash.Policy.Authorizer],
    data_layer: :embedded

  alias SoonReady.Application
  alias SoonReady.OutcomeDrivenInnovation.ValueObjects.{
    Market,
    JobStep,
    ScreeningQuestion,
    DemographicQuestion,
    ContextQuestion
  }

  alias SoonReady.IdentityAndAccessManagement.Checks.ActorIsResearcher

  attributes do
    uuid_primary_key :survey_id
    attribute :brand, :string
    attribute :market, Market
    attribute :job_steps, {:array, JobStep}
    attribute :screening_questions, {:array, ScreeningQuestion}
    attribute :demographic_questions, {:array, DemographicQuestion}
    attribute :context_questions, {:array, ContextQuestion}
  end

  policies do
    policy always() do
      authorize_if ActorIsResearcher
    end
  end


  actions do
    defaults [:create, :read]

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
    define_for SoonReady.OutcomeDrivenInnovation.Survey
    define :dispatch
    define :create
  end
end
