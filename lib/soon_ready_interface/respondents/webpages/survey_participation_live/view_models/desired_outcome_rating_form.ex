defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.ViewModels.DesiredOutcomeRatingForm do
  use Ash.Resource, data_layer: :embedded

  alias SoonReadyInterface.Respondents.ReadModels.ActiveOdiSurveys
  alias __MODULE__.{JobStep, DesiredOutcome}

  attributes do
    attribute :job_steps, {:array, JobStep}, allow_nil?: false
  end

  actions do
    defaults [:create, :read, :update]

    create :from_read_model do
      argument :survey, ActiveOdiSurveys, allow_nil?: false

      change fn changeset, _context ->
        read_model = Ash.Changeset.get_argument(changeset, :survey)

        job_steps = Enum.map(read_model.job_steps, fn job_step ->
          JobStep.create!(%{
            name: job_step.name,
            desired_outcomes: Enum.map(job_step.desired_outcomes, fn desired_outcome ->
              DesiredOutcome.create!(%{
                name: desired_outcome
              })
            end)
          })
        end)
        Ash.Changeset.change_attribute(changeset, :job_steps, job_steps)
      end
    end
  end

  code_interface do
    define_for SoonReadyInterface.Respondents.Setup.Api

    define :from_read_model do
      args [:survey]
    end
  end

  def normalize(%{__struct__: __MODULE__, job_steps: job_steps}) do
    job_steps
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {job_step, index}, job_steps ->
      Map.put(job_steps, "#{index}", %{
        "name" => job_step.name,
        "desired_outcomes" =>
          job_step.desired_outcomes
          |> Enum.with_index()
          |> Enum.reduce(%{}, fn {desired_outcome, index}, desired_outcomes ->
            Map.put(desired_outcomes, "#{index}", %{
              "name" => desired_outcome.name,
              "importance" => desired_outcome.importance,
              "satisfaction" => desired_outcome.satisfaction
            })
          end)
      })
    end)
  end
end
