defmodule SoonReady.SurveyManagement.UseCases do
  alias SoonReady.Application
  alias SoonReady.SurveyManagement.ValueObjects.OdiSurveyData
  alias SoonReady.SurveyManagement.Commands.PublishOdiSurvey

  def publish_odi_survey(%OdiSurveyData{} = odi_survey_data) do
    params = Map.from_struct(odi_survey_data)

    with {:ok, command} <- PublishOdiSurvey.new(params),
          :ok <- Application.dispatch(command)
    do
      {:ok, command}
    end
  end
end
