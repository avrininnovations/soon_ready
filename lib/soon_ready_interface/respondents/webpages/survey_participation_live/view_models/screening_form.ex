defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.ViewModels.ScreeningForm do
  use Ash.Resource, data_layer: :embedded

  alias SoonReadyInterface.Respondents.ReadModels.ActiveOdiSurveys
  alias __MODULE__.{Question, Option}

  attributes do
    attribute :questions, {:array, Question}, allow_nil?: false
  end

  calculations do
    calculate :all_responses_are_correct, :boolean, fn record, _context ->
      Enum.all?(record.questions, fn question ->
        Enum.any?(question.options, fn option ->
          option.is_correct && question.response == option.value
        end)
      end)
    end
  end

  changes do
    change load(:all_responses_are_correct)
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
    define_for SoonReadyInterface.Respondents.Setup.Api

    define :from_read_model do
      args [:survey]
    end
  end
end
