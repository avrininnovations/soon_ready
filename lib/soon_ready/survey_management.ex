defmodule SoonReady.SurveyManagement do
  use Ash.Domain

  alias SoonReady.Encryption.Resources.PersonalIdentifiableInformationEncryptionKey

  resources do
    # Aggregate
    resource SoonReady.SurveyManagement.Survey

    # Commands
    resource SoonReady.SurveyManagement.Commands.SubmitSurveyResponse

    # Domain Events
    resource SoonReady.SurveyManagement.DomainEvents.SurveyCreatedV1
    resource SoonReady.SurveyManagement.DomainEvents.SurveyPublishedV1
    resource SoonReady.SurveyManagement.DomainEvents.SurveyResponseSubmittedV1

    # Integration Events
    resource SoonReady.SurveyManagement.IntegrationEvents.SurveyPublishedV1
  end

  authorization do
    authorize :by_default
  end

  defdelegate submit_response(params), to: SubmitSurveyResponse, as: :dispatch
end
