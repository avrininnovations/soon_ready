defmodule SoonReady.SurveyManagement do
  use Ash.Domain

  alias SoonReady.SurveyManagement.Commands.{CreateSurvey, PublishSurvey, SubmitSurveyResponse}
  alias SoonReady.Encryption.Resources.PersonalIdentifiableInformationEncryptionKey

  resources do
    # Aggregate
    resource SoonReady.SurveyManagement.Survey

    # Commands
    resource SoonReady.SurveyManagement.Commands.CreateSurvey
    resource SoonReady.SurveyManagement.Commands.PublishSurvey
    resource SoonReady.SurveyManagement.Commands.SubmitSurveyResponse

    # DomainEvents
    resource SoonReady.SurveyManagement.DomainEvents.SurveyCreatedV1
    resource SoonReady.SurveyManagement.DomainEvents.SurveyPublishedV1
    resource SoonReady.SurveyManagement.DomainEvents.SurveyResponseSubmittedV1
  end

  authorization do
    authorize :by_default
  end

  defdelegate create_survey(params), to: CreateSurvey, as: :dispatch
  defdelegate publish_survey(params), to: PublishSurvey, as: :dispatch
  defdelegate submit_response(params), to: SubmitSurveyResponse, as: :dispatch
end
