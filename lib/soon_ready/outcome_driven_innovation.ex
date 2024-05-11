defmodule SoonReady.OutcomeDrivenInnovation do
  use Ash.Api

  alias SoonReady.OutcomeDrivenInnovation.Commands.{CreateSurvey, PublishSurvey}
  alias SoonReady.OutcomeDrivenInnovation.Commands.SubmitSurveyResponse
  alias SoonReady.Encryption.PersonalIdentifiableInformationEncryptionKey

  resources do
    resource SoonReady.Encryption.PersonalIdentifiableInformationEncryptionKey
  end

  authorization do
    authorize :by_default
  end

  def create_survey(params, actor \\ nil), do: CreateSurvey.dispatch(params, [actor: actor])
  defdelegate publish_survey(params), to: PublishSurvey, as: :dispatch
  defdelegate submit_response(params), to: SubmitSurveyResponse, as: :dispatch
end
