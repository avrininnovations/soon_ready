defmodule SoonReady.SurveyManagement do
  use Ash.Domain

  resources do
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
end
