# defmodule SoonReady.QuantifyingNeeds.Survey.Commands.Tests.PublishOdiSurveyTest do
#   use SoonReady.DataCase

#   import Commanded.Assertions.EventAssertions

#   alias SoonReady.Application
#   alias SoonReady.QuantifyingNeeds.Survey.Commands.PublishOdiSurvey
#   alias SoonReady.QuantifyingNeeds.Survey.DomainEvents.OdiSurveyPublished
#   alias SoonReady.QuantifyingNeeds.Survey.ValueObjects.{
#     Market,
#     JobStep,
#     ScreeningQuestion,
#     DemographicQuestion,
#     ContextQuestion
#   }

#   test "WHEN: An Avrin researcher tries to publish an ODI survey, THEN: An ODI survey is published" do
#     # TODO: Test the fact that the actor is an Avrin researcher

#     odi_survey_data = %{
#       brand: "A Big Brand",
#       market: %Market{
#         job_executor: "Persons",
#         job_to_be_done: "Do what persons do"
#       },
#       job_steps: [
#         %JobStep{name: "Job Step 1", desired_outcomes: [
#           "Minimize the time it takes to do A",
#           "Minimize the likelihood that B occurs"
#         ]},
#         %JobStep{name: "Job Step 2", desired_outcomes: [
#           "Minimize the time it takes to do C",
#           "Minimize the likelihood that D occurs"
#         ]},
#       ],
#       screening_questions: [
#         %ScreeningQuestion{prompt: "What is the answer to screening question 1?", options: [
#           %ScreeningQuestion.Option{value: "Option 1", is_correct: true},
#           %ScreeningQuestion.Option{value: "Option 2", is_correct: false},
#         ]},
#         %ScreeningQuestion{prompt: "What is the answer to screening question 2?", options: [
#           %ScreeningQuestion.Option{value: "Option 1", is_correct: true},
#           %ScreeningQuestion.Option{value: "Option 2", is_correct: false},
#         ]}
#       ],
#       demographic_questions: [
#         %DemographicQuestion{prompt: "What is the answer to demographic question 1?", options: ["Option 1", "Option 2"]},
#         %DemographicQuestion{prompt: "What is the answer to demographic question 2?", options: ["Option 1", "Option 2"]}
#       ],
#       context_questions: [
#         %ContextQuestion{prompt: "What is the answer to context question 1?", options: ["Option 1", "Option 2"]},
#         %ContextQuestion{prompt: "What is the answer to context question 2?", options: ["Option 1", "Option 2"]}
#       ]
#     }

#     with {:ok, %{survey_id: survey_id} = _command} <- PublishOdiSurvey.dispatch(odi_survey_data) do
#       assert_receive_event(Application, OdiSurveyPublished,
#         fn event -> event.survey_id == survey_id end,
#         fn event ->
#           assert SoonReady.Utils.is_equal_or_subset?(event.brand, odi_survey_data.brand)
#           assert SoonReady.Utils.is_equal_or_subset?(event.market, odi_survey_data.market)
#           assert SoonReady.Utils.is_equal_or_subset?(event.job_steps, odi_survey_data.job_steps)
#           assert SoonReady.Utils.is_equal_or_subset?(event.screening_questions, odi_survey_data.screening_questions)
#           assert SoonReady.Utils.is_equal_or_subset?(event.demographic_questions, odi_survey_data.demographic_questions)
#           assert SoonReady.Utils.is_equal_or_subset?(event.context_questions, odi_survey_data.context_questions)
#         end
#       )
#     else
#       {:error, error} ->
#         flunk("Expected ODI survey to be published but got: #{inspect(error)}")
#     end
#   end
# end
