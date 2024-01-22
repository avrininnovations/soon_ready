defmodule SoonReady.QuantifyNeeds.Survey do
  use Ash.Resource, data_layer: :embedded

  alias SoonReady.QuantifyNeeds.Survey.ValueObjects.{
    Market,
    JobStep,
    ScreeningQuestion,
    DemographicQuestion,
    ContextQuestion
  }
  alias SoonReady.QuantifyNeeds.Survey.Commands.{CreateSurvey, PublishSurvey}
  alias SoonReady.QuantifyNeeds.Survey.DomainEvents.{SurveyCreated, SurveyPublished}

  attributes do
    uuid_primary_key :id
    attribute :brand, :string, allow_nil?: false
    attribute :market, Market, allow_nil?: false
    attribute :job_steps, {:array, JobStep}, allow_nil?: false, constraints: [min_length: 1]
    attribute :screening_questions, {:array, ScreeningQuestion}, allow_nil?: false, constraints: [min_length: 1]
    attribute :demographic_questions, {:array, DemographicQuestion}, allow_nil?: false, constraints: [min_length: 1]
    attribute :context_questions, {:array, ContextQuestion}, allow_nil?: false, constraints: [min_length: 1]
  end

  actions do
    create :create do
      change fn changeset, _context ->
        Ash.Changeset.after_action(changeset, fn changeset, result ->
          result
          |> Map.from_struct()
          |> CreateSurvey.dispatch()
          |> case do
            {:ok, _command} ->
              {:ok, result}

            {:error, error} ->
              changeset = Ash.Changeset.add_error(changeset, error)
              {:error, changeset}
          end
        end)
      end
    end

    update :publish do
      change fn changeset, context ->
        Ash.Changeset.after_action(changeset, fn changeset, result ->
          case PublishSurvey.dispatch(%{id: result.id}) do
            {:ok, _command} ->
              {:ok, result}

            {:error, error} ->
              changeset = Ash.Changeset.add_error(changeset, error)
              {:error, changeset}
          end
        end)
      end
    end
  end

  code_interface do
    define_for SoonReady.QuantifyNeeds.Survey.Api
    define :create
    define :publish
  end


  # Command Handling
  use Commanded.Commands.Router
  dispatch CreateSurvey, to: __MODULE__, identity: :id
  dispatch PublishSurvey, to: __MODULE__, identity: :id

  def execute(_aggregate_state, %CreateSurvey{} = command) do
    SurveyCreated.new(%{
      id: command.id,
      brand: command.brand,
      market: command.market,
      job_steps: command.job_steps,
      screening_questions: command.screening_questions,
      demographic_questions: command.demographic_questions,
      context_questions: command.context_questions
    })
  end

  def execute(_aggregate_state, %PublishSurvey{} = command) do
    SurveyPublished.new(%{
      id: command.id
    })
  end

  def apply(state, _event) do
    state
  end
end
