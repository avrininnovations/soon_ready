defmodule SoonReadyWeb.Respondents.Web.SurveyParticipationLive.ViewModels.ScreeningForm do
  use Ash.Resource, data_layer: :embedded

  alias SoonReadyWeb.Respondents.ReadModels.ActiveOdiSurveys
  alias __MODULE__.{Question, Option}

  attributes do
    attribute :questions, {:array, Question}, allow_nil?: false
  end

  actions do
    defaults [:create, :read, :update]

    create :from_read_model do
      argument :survey, ActiveOdiSurveys, allow_nil?: false

      change fn changeset, _context ->
        read_model = Ash.Changeset.get_argument(changeset, :survey)

        questions = Enum.map(read_model.screening_questions, fn screening_question ->
          Question.create!(%{
            prompt: screening_question.prompt,
            options: Enum.map(screening_question.options, fn option ->
              Option.create!(%{
                value: option.value,
                is_correct: option.is_correct
              })
            end)
          })
        end)
        Ash.Changeset.change_attribute(changeset, :questions, questions)
        # |> IO.inspect(label: "changeset")
      end
    end
  end

  code_interface do
    define_for SoonReadyWeb.Respondents.Setup.Api

    define :from_read_model do
      args [:survey]
    end
  end
end
